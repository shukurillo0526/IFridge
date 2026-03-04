// I-Fridge — Meal Planner Deep Page
// ====================================
// Full calendar view with date-recipe assignments, monthly overview.
// Uses meal_plan table: id, user_id, recipe_id, planned_date, meal_type, notes

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ifridge_app/core/theme/app_theme.dart';
import 'package:ifridge_app/core/services/auth_helper.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({super.key});
  @override
  State<MealPlannerPage> createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();
  Map<String, List<Map<String, dynamic>>> _mealsByDate = {};
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final uid = currentUserId();
      final startOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
      final endOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
      final data = await Supabase.instance.client
          .from('meal_plan')
          .select('*, recipes(title)')
          .eq('user_id', uid)
          .gte('planned_date', startOfMonth.toIso8601String().substring(0, 10))
          .lte('planned_date', endOfMonth.toIso8601String().substring(0, 10))
          .order('meal_type');
      final map = <String, List<Map<String, dynamic>>>{};
      for (final row in (data as List)) {
        final date = row['planned_date'] as String;
        map.putIfAbsent(date, () => []).add(Map<String, dynamic>.from(row));
      }
      setState(() { _mealsByDate = map; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _addMeal(String mealType) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Plan $mealType', style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g. Grilled chicken salad',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            filled: true, fillColor: AppTheme.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: IFridgeTheme.primary),
            child: const Text('Add')),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    try {
      final uid = currentUserId();
      await Supabase.instance.client.from('meal_plan').upsert({
        'user_id': uid,
        'planned_date': _dateKey(_selectedDate),
        'meal_type': mealType,
        'notes': result,
      }, onConflict: 'user_id,planned_date,meal_type');
      _load();
    } catch (_) {}
  }

  Future<void> _removeMeal(String mealId) async {
    try {
      await Supabase.instance.client.from('meal_plan').delete().eq('id', mealId);
      _load();
    } catch (_) {}
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + delta);
      _loading = true;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday;
    final todayKey = _dateKey(DateTime.now());
    final selectedKey = _dateKey(_selectedDate);
    final mealsForDay = _mealsByDate[selectedKey] ?? [];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Meal Planner', style: TextStyle(fontWeight: FontWeight.w700))),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: IFridgeTheme.primary))
          : Column(
              children: [
                // Month navigation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () => _changeMonth(-1),
                        icon: const Icon(Icons.chevron_left, color: Colors.white)),
                      Text('${monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      IconButton(onPressed: () => _changeMonth(1),
                        icon: const Icon(Icons.chevron_right, color: Colors.white)),
                    ],
                  ),
                ),

                // Calendar grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      // Day headers
                      Row(
                        children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map((d) =>
                          Expanded(child: Center(child: Text(d,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12))))).toList(),
                      ),
                      const SizedBox(height: 4),
                      // Day cells
                      ...List.generate(((firstWeekday - 1 + daysInMonth) / 7).ceil(), (week) {
                        return Row(
                          children: List.generate(7, (dow) {
                            final dayNum = week * 7 + dow - (firstWeekday - 2);
                            if (dayNum < 1 || dayNum > daysInMonth) return const Expanded(child: SizedBox(height: 40));
                            final date = DateTime(_selectedMonth.year, _selectedMonth.month, dayNum);
                            final key = _dateKey(date);
                            final isToday = key == todayKey;
                            final isSelected = key == selectedKey;
                            final hasMeals = _mealsByDate.containsKey(key);
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedDate = date),
                                child: Container(
                                  height: 40,
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? IFridgeTheme.primary
                                        : isToday ? IFridgeTheme.primary.withValues(alpha: 0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isToday && !isSelected ? Border.all(color: IFridgeTheme.primary.withValues(alpha: 0.4)) : null),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('$dayNum',
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : isToday ? IFridgeTheme.primary : Colors.white70,
                                            fontSize: 13, fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w400)),
                                        if (hasMeals)
                                          Container(width: 4, height: 4, margin: const EdgeInsets.only(top: 2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected ? Colors.white : IFridgeTheme.primary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 24),

                // Meals for selected date
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(_selectedDate.day == DateTime.now().day &&
                          _selectedDate.month == DateTime.now().month ? 'Today' :
                          '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text('${mealsForDay.length} meals',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final type in ['breakfast', 'lunch', 'dinner', 'snack']) ...[
                        _MealTypeRow(
                          type: type,
                          meals: mealsForDay.where((m) => m['meal_type'] == type).toList(),
                          onAdd: () => _addMeal(type),
                          onRemove: _removeMeal,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _MealTypeRow extends StatelessWidget {
  final String type;
  final List<Map<String, dynamic>> meals;
  final VoidCallback onAdd;
  final void Function(String id) onRemove;
  const _MealTypeRow({required this.type, required this.meals, required this.onAdd, required this.onRemove});

  IconData get _icon => switch (type) {
    'breakfast' => Icons.wb_sunny,
    'lunch' => Icons.restaurant,
    'dinner' => Icons.nightlight_round,
    _ => Icons.cookie,
  };

  Color get _color => switch (type) {
    'breakfast' => Colors.orange,
    'lunch' => IFridgeTheme.primary,
    'dinner' => Colors.deepPurple,
    _ => Colors.pink,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, size: 18, color: _color),
              const SizedBox(width: 8),
              Text(type[0].toUpperCase() + type.substring(1),
                style: TextStyle(color: _color, fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              GestureDetector(
                onTap: onAdd,
                child: Icon(Icons.add_circle_outline, size: 20, color: _color.withValues(alpha: 0.6))),
            ],
          ),
          if (meals.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Tap + to plan',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12, fontStyle: FontStyle.italic)))
          else
            ...meals.map((m) {
              final recipeMeta = m['recipes'] as Map?;
              final name = recipeMeta?['title'] ?? m['notes'] ?? 'Meal';
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text('• $name', style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => onRemove(m['id']),
                      child: Icon(Icons.close, size: 16, color: Colors.white.withValues(alpha: 0.3))),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
