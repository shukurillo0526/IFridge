// I-Fridge — Nutrition Tracker Deep Page
// ========================================
// Daily calorie ring, macro bars, and meal log history.

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ifridge_app/core/theme/app_theme.dart';
import 'package:ifridge_app/core/services/api_service.dart';
import 'package:ifridge_app/core/services/auth_helper.dart';

class NutritionTrackerPage extends StatefulWidget {
  const NutritionTrackerPage({super.key});
  @override
  State<NutritionTrackerPage> createState() => _NutritionTrackerPageState();
}

class _NutritionTrackerPageState extends State<NutritionTrackerPage> {
  final ApiService _api = ApiService();
  Map<String, dynamic>? _daily;
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final uid = currentUserId();
      final result = await _api.getDailyNutrition(uid);
      setState(() { _daily = result; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() { _api.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Nutrition Tracker', style: TextStyle(fontWeight: FontWeight.w700))),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: IFridgeTheme.primary))
          : RefreshIndicator(
              color: IFridgeTheme.primary,
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Calorie Ring
                  _buildCalorieRing(),
                  const SizedBox(height: 24),

                  // Macro Bars
                  _buildMacroBars(),
                  const SizedBox(height: 24),

                  // Meal Log
                  const Text('Today\'s Meals',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _buildMealLog(),
                ],
              ),
            ),
    );
  }

  Widget _buildCalorieRing() {
    final totals = _daily?['totals'] as Map<String, dynamic>? ?? {};
    final consumed = (totals['calories'] ?? 0).toDouble();
    final goal = (_daily?['goal'] ?? 2000).toDouble();
    final pct = (consumed / goal).clamp(0.0, 1.5);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
      child: Column(
        children: [
          SizedBox(
            width: 180, height: 180,
            child: CustomPaint(
              painter: _RingPainter(pct, pct > 1.0 ? Colors.red : Colors.orange),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${consumed.toInt()}',
                      style: const TextStyle(color: Colors.orange, fontSize: 36, fontWeight: FontWeight.w800)),
                    Text('/ ${goal.toInt()} cal',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(pct > 1.0 ? '⚠️ Over goal!' : '${((1.0 - pct) * goal).toInt()} cal remaining',
            style: TextStyle(
              color: pct > 1.0 ? Colors.red : Colors.white.withValues(alpha: 0.5),
              fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMacroBars() {
    final totals = _daily?['totals'] as Map<String, dynamic>? ?? {};
    final macros = [
      {'label': 'Protein', 'value': totals['protein_g'] ?? 0, 'color': Colors.blue, 'goal': 120},
      {'label': 'Carbs', 'value': totals['carbs_g'] ?? 0, 'color': Colors.amber, 'goal': 250},
      {'label': 'Fat', 'value': totals['fat_g'] ?? 0, 'color': Colors.red, 'goal': 65},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
      child: Column(
        children: macros.map((m) {
          final pct = ((m['value'] as int) / (m['goal'] as int)).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(width: 60, child: Text(m['label'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 13))),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct, minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation(m['color'] as Color)),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(width: 70, child: Text('${m['value']}/${m['goal']}g',
                  textAlign: TextAlign.end,
                  style: TextStyle(color: (m['color'] as Color), fontSize: 12, fontWeight: FontWeight.w600))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMealLog() {
    final meals = (_daily?['meals'] as List?) ?? [];
    if (meals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(16)),
        child: Center(child: Text('No meals logged today.\nUse Scan Calories to log your food!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.4)))),
      );
    }
    return Column(
      children: meals.map<Widget>((meal) {
        final type = meal['meal_type'] ?? 'snack';
        final cal = meal['total_calories'] ?? 0;
        final emoji = {'breakfast': '🌅', 'lunch': '☀️', 'dinner': '🌙', 'snack': '🍿'}[type] ?? '🍽️';
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(child: Text('${type[0].toUpperCase()}${type.substring(1)}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600))),
              Text('$cal cal', style: const TextStyle(color: Colors.orange, fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RingPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 12;
    canvas.drawCircle(center, r, Paint()..color = Colors.white.withOpacity(0.06)..style = PaintingStyle.stroke..strokeWidth = 12);
    final arc = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: r), -math.pi / 2, 2 * math.pi * progress.clamp(0.0, 1.0), false, arc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
