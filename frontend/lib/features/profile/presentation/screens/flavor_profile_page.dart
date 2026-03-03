// I-Fridge — Flavor Profile Deep Page
// =====================================
// Full-screen view of the user's flavor preferences.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ifridge_app/core/theme/app_theme.dart';
import 'package:ifridge_app/core/services/auth_helper.dart';

class FlavorProfilePage extends StatefulWidget {
  const FlavorProfilePage({super.key});
  @override
  State<FlavorProfilePage> createState() => _FlavorProfilePageState();
}

class _FlavorProfilePageState extends State<FlavorProfilePage> {
  Map<String, double> _flavors = {};
  bool _loading = true;

  final _flavorMeta = {
    'sweet': {'emoji': '🍯', 'color': Colors.amber},
    'salty': {'emoji': '🧂', 'color': Colors.blue},
    'spicy': {'emoji': '🌶️', 'color': Colors.red},
    'sour': {'emoji': '🍋', 'color': Colors.lime},
    'umami': {'emoji': '🍖', 'color': Colors.deepOrange},
    'bitter': {'emoji': '🍵', 'color': Colors.teal},
  };

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final uid = currentUserId();
      final row = await Supabase.instance.client
          .from('user_flavor_profile').select().eq('user_id', uid).maybeSingle();
      if (row != null) {
        _flavors = {
          'sweet': (row['sweet'] ?? 0).toDouble(),
          'salty': (row['salty'] ?? 0).toDouble(),
          'spicy': (row['spicy'] ?? 0).toDouble(),
          'sour': (row['sour'] ?? 0).toDouble(),
          'umami': (row['umami'] ?? 0).toDouble(),
          'bitter': (row['bitter'] ?? 0).toDouble(),
        };
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Flavor Profile', style: TextStyle(fontWeight: FontWeight.w700))),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: IFridgeTheme.primary))
          : _flavors.isEmpty
              ? Center(child: Text('Cook more recipes to build your flavor profile!',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5))))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Radar chart placeholder
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        color: AppTheme.surface, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
                      child: CustomPaint(
                        painter: _RadarPainter(_flavors),
                        child: const Center(child: Text('🍳', style: TextStyle(fontSize: 32))),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Detailed bars
                    ..._flavors.entries.map((e) {
                      final meta = _flavorMeta[e.key];
                      final color = (meta?['color'] as Color?) ?? Colors.white;
                      final emoji = (meta?['emoji'] as String?) ?? '❓';
                      final pct = (e.value / 100).clamp(0.0, 1.0);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('$emoji  ${e.key[0].toUpperCase()}${e.key.substring(1)}',
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Text('${e.value.toInt()}%',
                                  style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: pct, minHeight: 10,
                                backgroundColor: Colors.white.withValues(alpha: 0.08),
                                valueColor: AlwaysStoppedAnimation(color)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Map<String, double> data;
  _RadarPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2.5;
    final values = data.values.toList();
    final n = values.length;
    if (n == 0) return;

    // Grid
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.08)..style = PaintingStyle.stroke;
    for (int ring = 1; ring <= 3; ring++) {
      final rr = r * ring / 3;
      final path = Path();
      for (int i = 0; i <= n; i++) {
        final a = -math.pi / 2 + 2 * math.pi * (i % n) / n;
        final pt = Offset(center.dx + rr * math.cos(a), center.dy + rr * math.sin(a));
        i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(path, gridPaint);
    }

    // Data polygon
    final fillPaint = Paint()..color = const Color(0xFF00E676).withOpacity(0.2)..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = const Color(0xFF00E676)..style = PaintingStyle.stroke..strokeWidth = 2;
    final dataPath = Path();
    for (int i = 0; i <= n; i++) {
      final v = (values[i % n] / 100).clamp(0.0, 1.0);
      final a = -math.pi / 2 + 2 * math.pi * (i % n) / n;
      final pt = Offset(center.dx + r * v * math.cos(a), center.dy + r * v * math.sin(a));
      i == 0 ? dataPath.moveTo(pt.dx, pt.dy) : dataPath.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
