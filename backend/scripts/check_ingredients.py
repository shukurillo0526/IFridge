"""Verify translation coverage after 012a + 012b."""
from app.db.supabase_client import get_supabase

db = get_supabase()
r = db.table("ingredients").select(
    "canonical_name, display_name_en, display_name_ko, display_name_uz, display_name_ru"
).execute()

total = len(r.data)
has_ko = sum(1 for i in r.data if i.get("display_name_ko"))
has_uz = sum(1 for i in r.data if i.get("display_name_uz"))
has_ru = sum(1 for i in r.data if i.get("display_name_ru"))

print(f"Total: {total}")
print(f"  Korean:  {has_ko}/{total} ({has_ko*100//total}%)")
print(f"  Uzbek:   {has_uz}/{total} ({has_uz*100//total}%)")
print(f"  Russian: {has_ru}/{total} ({has_ru*100//total}%)")

# Find missing
missing_ko = [i["canonical_name"] for i in r.data if not i.get("display_name_ko")]
missing_uz = [i["canonical_name"] for i in r.data if not i.get("display_name_uz")]
missing_ru = [i["canonical_name"] for i in r.data if not i.get("display_name_ru")]

if missing_ko:
    print(f"\nMissing Korean ({len(missing_ko)}): {', '.join(missing_ko[:20])}")
if missing_uz:
    print(f"\nMissing Uzbek ({len(missing_uz)}): {', '.join(missing_uz[:20])}")
if missing_ru:
    print(f"\nMissing Russian ({len(missing_ru)}): {', '.join(missing_ru[:20])}")
