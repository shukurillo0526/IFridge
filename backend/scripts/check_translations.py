"""Check translation state."""
from app.db.supabase_client import get_supabase

db = get_supabase()

# Check recipe_translations
rt = db.table("recipe_translations").select("*").execute()
print(f"Total recipe_translations rows: {len(rt.data)}")

# Check status breakdown
status_counts = {}
method_counts = {}
for row in rt.data:
    s = row.get("translation_status", "unknown")
    m = row.get("translation_method", "unknown")
    status_counts[s] = status_counts.get(s, 0) + 1
    method_counts[m] = method_counts.get(m, 0) + 1

print(f"  By status: {status_counts}")
print(f"  By method: {method_counts}")

# Show a few with actual content
has_title = [r for r in rt.data if r.get("title")]
print(f"  Have title: {len(has_title)}")

for r in has_title[:5]:
    print(f"    [{r.get('language_code')}] {r.get('title')[:60]}")

# Check if empty titles exist
empty_title = [r for r in rt.data if not r.get("title")]
print(f"  Empty titles: {len(empty_title)}")
