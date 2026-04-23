"""
I-Fridge — Standardized API Response Models
=============================================
All API endpoints should use these response wrappers for consistent
response shapes across the entire backend.

Usage:
    from app.models.api_response import ApiResponse, api_success, api_error

    @router.post("/api/v1/something")
    async def my_endpoint():
        data = do_work()
        return api_success(data, message="Done!")
"""

from pydantic import BaseModel
from typing import Any, Optional, Literal
from datetime import datetime


class ApiMeta(BaseModel):
    """Optional metadata for paginated or timed responses."""
    total: Optional[int] = None
    page: Optional[int] = None
    per_page: Optional[int] = None
    processing_ms: Optional[float] = None
    source: Optional[str] = None  # "ollama", "gemini", "mock", etc.


class ApiResponse(BaseModel):
    """Standardized API response envelope.
    
    Every endpoint should return this shape:
    {
        "status": "success" | "error" | "partial",
        "data": <any payload>,
        "message": "human-readable status",
        "error": "error details if status=error",
        "meta": { optional metadata }
    }
    """
    status: Literal["success", "error", "partial"] = "success"
    data: Any = None
    message: Optional[str] = None
    error: Optional[str] = None
    meta: Optional[ApiMeta] = None


def api_success(
    data: Any = None,
    message: str = "OK",
    meta: Optional[ApiMeta] = None,
) -> dict:
    """Helper to build a success response dict."""
    resp = {"status": "success", "data": data, "message": message}
    if meta:
        resp["meta"] = meta.model_dump(exclude_none=True)
    return resp


def api_error(
    error: str,
    message: str = "Request failed",
    status_code_hint: int = 500,
) -> dict:
    """Helper to build an error response dict.
    
    Note: This returns a dict, not raises an HTTPException.
    For HTTP errors, raise HTTPException directly.
    """
    return {"status": "error", "data": None, "message": message, "error": error}


def api_partial(
    data: Any = None,
    message: str = "Partial results",
    error: Optional[str] = None,
    meta: Optional[ApiMeta] = None,
) -> dict:
    """Helper for partial success (e.g., some items failed)."""
    resp = {"status": "partial", "data": data, "message": message}
    if error:
        resp["error"] = error
    if meta:
        resp["meta"] = meta.model_dump(exclude_none=True)
    return resp
