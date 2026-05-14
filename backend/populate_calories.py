import asyncio
import os
import httpx
from supabase import create_client, Client

from dotenv import load_dotenv
load_dotenv()

SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

async def main():
    print("Fetching recipes...")
    recipes = supabase.table("recipes").select("id, servings").execute().data
    
    # Plately API URL
    api_base = "http://127.0.0.1:8000"
    
    updated_count = 0
    
    async with httpx.AsyncClient() as client:
        for r in recipes:
            try:
                # Call the calorie endpoint locally
                res = await client.get(f"{api_base}/api/v1/calories/recipe/{r['id']}")
                if res.status_code == 200:
                    data = res.json()
                    totals = data.get("totals", {})
                    calories = totals.get("calories", 0)
                    
                    if calories > 0:
                        # Convert total to per-serving
                        servings = r.get("servings") or 2
                        cal_per_serving = int(calories / servings)
                        
                        # Update DB
                        supabase.table("recipes").update({"calories_per_serving": cal_per_serving}).eq("id", r["id"]).execute()
                        updated_count += 1
                        print(f"Updated recipe {r['id'][:8]}: {cal_per_serving} kcal/srv")
            except Exception as e:
                print(f"Error on {r['id']}: {e}")

    print(f"Updated {updated_count} recipes with calories_per_serving!")

if __name__ == "__main__":
    asyncio.run(main())
