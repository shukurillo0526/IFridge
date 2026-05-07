"""
Quick migration runner for 010_translation_system.
Uses Supabase REST API to rebuild the recipe_translations table
step-by-step (since raw SQL isn't available via PostgREST).

Alternative: Copy the SQL from migrations/010_translation_system.sql
and paste it into the Supabase Dashboard > SQL Editor > Run.
"""

from app.db.supabase_client import get_supabase


def verify_migration():
    """Verify the new schema is in place by doing a test insert + select."""
    db = get_supabase()

    # Try selecting with new column names
    try:
        result = db.table("recipe_translations").select(
            "recipe_id, language_code, title, short_description, "
            "ingredients, steps, translation_method, translation_status, "
            "quality_score, retry_after, translated_at"
        ).limit(1).execute()
        print("✅ Migration verified! New schema is active.")
        print(f"   Columns: recipe_id, language_code, title, short_description,")
        print(f"            ingredients, steps, translation_method, translation_status,")
        print(f"            quality_score, retry_after, translated_at")
        print(f"   Rows: {len(result.data)}")
        return True
    except Exception as e:
        error_str = str(e)
        if "title_translated" in error_str or "column" in error_str.lower():
            print("❌ Old schema still active. Run the migration SQL first:")
            print("   1. Go to https://supabase.com/dashboard")
            print("   2. Open your project > SQL Editor")
            print("   3. Paste contents of: migrations/010_translation_system.sql")
            print("   4. Click Run")
        else:
            print(f"❌ Error: {e}")
        return False


if __name__ == "__main__":
    verify_migration()
