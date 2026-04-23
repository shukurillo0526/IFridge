"""
I-Fridge — Inventory API Router
=================================
Handles ingredient upsert and inventory item creation.
Uses the service role key to bypass RLS restrictions.
"""

import logging
from datetime import datetime, timedelta
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional

from app.db.supabase_client import get_supabase

logger = logging.getLogger("ifridge.inventory")

router = APIRouter()


class AddItemRequest(BaseModel):
    user_id: str
    ingredient_name: str
    category: str = "Pantry"
    quantity: float = 1.0
    unit: str = "pcs"
    location: str = "Fridge"
    expiry_date: Optional[str] = None  # ISO 8601, defaults to 7 days


@router.post("/api/v1/inventory/add-item")
async def add_inventory_item(req: AddItemRequest):
    """
    Upsert an ingredient and add it to inventory.
    If the same ingredient already exists in the same location,
    increments quantity instead of creating a duplicate.
    Uses the service role key, so RLS is bypassed.
    """
    db = get_supabase()

    try:
        # 1. Find or create ingredient (fetch full metadata)
        existing = (
            db.table("ingredients")
            .select("*")
            .ilike("display_name_en", req.ingredient_name)
            .limit(1)
            .execute()
        )

        if existing.data and len(existing.data) > 0:
            ingredient = existing.data[0]
            ingredient_id = ingredient["id"]
        else:
            # Try canonical_name match as well
            canonical = req.ingredient_name.strip().lower().replace(" ", "_")
            canonical_match = (
                db.table("ingredients")
                .select("*")
                .eq("canonical_name", canonical)
                .limit(1)
                .execute()
            )
            if canonical_match.data and len(canonical_match.data) > 0:
                ingredient = canonical_match.data[0]
                ingredient_id = ingredient["id"]
            else:
                # Create new ingredient
                inserted = (
                    db.table("ingredients")
                    .insert({
                        "canonical_name": canonical,
                        "display_name_en": req.ingredient_name.strip(),
                        "category": req.category,
                        "default_unit": req.unit,
                    })
                    .execute()
                )
                ingredient = inserted.data[0]
                ingredient_id = ingredient["id"]

        # 2. Auto-compute expiry from ingredient shelf-life data
        location = req.location.lower()
        shelf_days = ingredient.get("sealed_shelf_life_days")
        if req.expiry_date:
            expiry = req.expiry_date
        elif shelf_days:
            expiry = (datetime.now() + timedelta(days=shelf_days)).strftime("%Y-%m-%d")
        else:
            # Category-level fallback
            cat_defaults = {
                "protein": 5, "seafood": 3, "vegetable": 14, "fruit": 10,
                "dairy": 30, "grain": 365, "baking": 365, "seasoning": 730,
                "condiment": 365, "oil": 365, "legume": 365, "nut": 180,
                "beverage": 30,
            }
            cat = (ingredient.get("category") or req.category or "").lower()
            fallback_days = cat_defaults.get(cat, 14)
            expiry = (datetime.now() + timedelta(days=fallback_days)).strftime("%Y-%m-%d")

        # Check if item already exists for this user+ingredient+location
        existing_inv = (
            db.table("inventory_items")
            .select("id, quantity")
            .eq("user_id", req.user_id)
            .eq("ingredient_id", ingredient_id)
            .eq("location", location)
            .limit(1)
            .execute()
        )

        if existing_inv.data and len(existing_inv.data) > 0:
            # Update quantity (add to existing)
            old_qty = existing_inv.data[0]["quantity"]
            new_qty = old_qty + req.quantity
            db.table("inventory_items").update({
                "quantity": new_qty,
                "manual_expiry_date": expiry,
            }).eq("id", existing_inv.data[0]["id"]).execute()

            logger.info(f"[Inventory] Updated {req.ingredient_name} qty: {old_qty} → {new_qty}")
            return {
                "status": "updated",
                "ingredient_id": ingredient_id,
                "category": ingredient.get("category"),
                "default_unit": ingredient.get("default_unit"),
                "shelf_life_days": shelf_days,
                "storage_zone": ingredient.get("storage_zone"),
                "calories_per_100g": ingredient.get("calories_per_100g"),
                "message": f"Updated {req.ingredient_name} quantity to {new_qty}",
            }
        else:
            # Insert new inventory item
            db.table("inventory_items").insert({
                "user_id": req.user_id,
                "ingredient_id": ingredient_id,
                "quantity": req.quantity,
                "unit": req.unit,
                "location": location,
                "manual_expiry_date": expiry,
            }).execute()

            logger.info(f"[Inventory] Added {req.ingredient_name} (id={ingredient_id})")
            return {
                "status": "success",
                "ingredient_id": ingredient_id,
                "category": ingredient.get("category"),
                "default_unit": ingredient.get("default_unit"),
                "shelf_life_days": shelf_days,
                "storage_zone": ingredient.get("storage_zone"),
                "calories_per_100g": ingredient.get("calories_per_100g"),
                "message": f"Added {req.ingredient_name} to shelf",
            }

    except Exception as e:
        logger.error(f"[Inventory] Failed to add item: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/api/v1/ingredients/search")
async def search_ingredients(q: str, limit: int = 8):
    """
    Search ingredients by name (EN, KO, canonical).
    Returns full metadata for auto-fill.
    """
    db = get_supabase()
    try:
        # Search across multiple name fields
        results = (
            db.table("ingredients")
            .select("*")
            .or_(
                f"display_name_en.ilike.%{q}%,"
                f"display_name_ko.ilike.%{q}%,"
                f"canonical_name.ilike.%{q}%"
            )
            .limit(limit)
            .execute()
        )
        return {"ingredients": results.data}
    except Exception as e:
        logger.error(f"[Ingredients] Search failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


class UpdateItemRequest(BaseModel):
    quantity: Optional[float] = None
    unit: Optional[str] = None
    item_state: Optional[str] = None
    location: Optional[str] = None
    notes: Optional[str] = None


@router.patch("/api/v1/inventory/{item_id}")
async def update_inventory_item(item_id: str, req: UpdateItemRequest):
    """Update an inventory item's properties."""
    db = get_supabase()

    try:
        update_data = {}
        if req.quantity is not None:
            update_data["quantity"] = req.quantity
        if req.unit is not None:
            update_data["unit"] = req.unit
        if req.item_state is not None:
            update_data["item_state"] = req.item_state
        if req.location is not None:
            update_data["location"] = req.location
        if req.notes is not None:
            update_data["notes"] = req.notes

        if not update_data:
            return {"status": "no_changes"}

        db.table("inventory_items").update(update_data).eq("id", item_id).execute()

        logger.info(f"[Inventory] Updated item {item_id}")
        return {"status": "success"}

    except Exception as e:
        logger.error(f"[Inventory] Update failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/api/v1/inventory/{item_id}")
async def delete_inventory_item(item_id: str):
    """Delete an inventory item."""
    db = get_supabase()

    try:
        db.table("inventory_items").delete().eq("id", item_id).execute()
        logger.info(f"[Inventory] Deleted item {item_id}")
        return {"status": "success"}

    except Exception as e:
        logger.error(f"[Inventory] Delete failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


class ConsumeItemRequest(BaseModel):
    inventory_id: str
    quantity_to_consume: float


@router.post("/api/v1/inventory/consume")
async def consume_inventory_item(req: ConsumeItemRequest):
    """
    Consume (decrement) an inventory item's quantity.
    Uses the consume_inventory_item RPC which auto-deletes at 0.
    """
    db = get_supabase()

    try:
        db.rpc(
            "consume_inventory_item",
            {
                "p_inventory_id": req.inventory_id,
                "p_qty_to_consume": req.quantity_to_consume,
            },
        ).execute()

        logger.info(
            f"[Inventory] Consumed {req.quantity_to_consume} from {req.inventory_id}"
        )
        return {"status": "success"}

    except Exception as e:
        logger.error(f"[Inventory] Consume failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))


# ── Smart Expiry Prediction ──────────────────────────────────────

class PredictExpiryRequest(BaseModel):
    category: str
    purchase_date: Optional[str] = None  # ISO date
    storage_location: str = "fridge"
    packaging: str = "opened"  # "opened" or "sealed"


@router.post("/api/v1/inventory/predict-expiry")
async def predict_expiry_endpoint(req: PredictExpiryRequest):
    """
    Predict expiry date using category, storage location, and packaging.
    
    Uses smart defaults based on food science data:
    - Category-based shelf life (e.g., meat=3d, dairy=10d)
    - Storage multiplier (freezer=6x, pantry=0.5x)
    - Packaging factor (sealed=+50%)
    """
    from app.services.expiry_prediction import predict_expiry
    from datetime import date

    purchase = None
    if req.purchase_date:
        purchase = date.fromisoformat(req.purchase_date)

    result = predict_expiry(
        category=req.category.lower(),
        purchase_date=purchase,
        storage_location=req.storage_location.lower(),
        packaging=req.packaging.lower(),
    )
    return {"status": "success", "data": result}


# ── Visual Freshness Detection ───────────────────────────────────

from fastapi import File, UploadFile, Form

@router.post("/api/v1/inventory/assess-freshness")
async def assess_freshness(
    image: UploadFile = File(...),
    ingredient_name: str = Form(...),
    category: str = Form("other"),
):
    """
    Analyze a photo of an ingredient to assess its freshness.
    
    Uses vision AI to detect visual cues (brown spots, wilting,
    color changes) and return a freshness score (0.0-1.0)
    with an adjusted expiry recommendation.
    
    Returns:
        freshness_score, visual_cues, recommendation,
        days_remaining_estimate, adjusted_expiry
    """
    from app.services.expiry_prediction import assess_freshness_from_photo

    image_bytes = await image.read()
    if len(image_bytes) > 10 * 1024 * 1024:
        raise HTTPException(status_code=413, detail="Image too large (max 10MB)")

    result = await assess_freshness_from_photo(
        image_bytes=image_bytes,
        ingredient_name=ingredient_name,
        category=category.lower(),
    )

    if "error" in result and "AI unavailable" in str(result.get("error", "")):
        raise HTTPException(status_code=503, detail="AI service unavailable")

    return {"status": "success", "data": result}
