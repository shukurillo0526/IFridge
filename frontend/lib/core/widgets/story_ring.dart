// I-Fridge — Story Ring
// ======================
// Horizontal scrollable row of user story avatars.
// - Gradient ring = has unviewed stories
// - Grey ring = all viewed
// - "+" button = add your own story
// Lives at top of the Community feed tab.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ifridge_app/core/theme/app_theme.dart';
import 'package:ifridge_app/core/services/story_service.dart';
import 'package:ifridge_app/core/widgets/story_viewer.dart';

class StoryRing extends StatefulWidget {
  const StoryRing({super.key});

  @override
  State<StoryRing> createState() => StoryRingState();
}

class StoryRingState extends State<StoryRing> {
  List<StoryGroup> _groups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadStories();
  }

  Future<void> loadStories() async {
    final groups = await StoryService.getStoryGroups();
    if (mounted) setState(() { _groups = groups; _loading = false; });
  }

  void _openStoryViewer(int index) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => StoryViewer(
          groups: _groups,
          initialGroupIndex: index,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    if (result == true) loadStories(); // Refresh if a story was deleted
  }

  void _addStory() async {
    // Show bottom sheet to pick camera or gallery
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: IFridgeTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Add Story',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _sourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => Navigator.pop(ctx, ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _sourceButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (source == null) return;

    // Pick image
    final file = await StoryService.pickStoryImage(source: source);
    if (file == null) return;

    // Show uploading indicator
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(children: [
          SizedBox(width: 16, height: 16,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
          SizedBox(width: 12),
          Text('Uploading story...'),
        ]),
        backgroundColor: IFridgeTheme.primary,
        duration: Duration(seconds: 10),
      ),
    );

    // Upload media
    final url = await StoryService.uploadStoryMedia(file);
    if (url == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Create story
    final success = await StoryService.createStory(mediaUrl: url);
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Story posted!'),
          backgroundColor: IFridgeTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      loadStories(); // Refresh ring
    }
  }

  Widget _sourceButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: IFridgeTheme.bgElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: IFridgeTheme.primary, size: 28),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: _loading
          ? const Center(
              child: SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(color: IFridgeTheme.primary, strokeWidth: 2)),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // ── Add Story Button ──
                _AddStoryAvatar(onTap: _addStory),

                // ── Story groups ──
                ..._groups.asMap().entries.map((entry) {
                  final group = entry.value;
                  return _StoryAvatar(
                    name: group.isOwn ? 'You' : group.userName,
                    hasUnviewed: group.hasUnviewed,
                    isOwn: group.isOwn,
                    storyCount: group.stories.length,
                    onTap: () => _openStoryViewer(entry.key),
                  );
                }),
              ],
            ),
    );
  }
}

// ── Add Story Avatar ──

class _AddStoryAvatar extends StatelessWidget {
  final VoidCallback onTap;
  const _AddStoryAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: IFridgeTheme.bgElevated,
                border: Border.all(color: IFridgeTheme.primary.withValues(alpha: 0.4), width: 2),
              ),
              child: const Center(
                child: Icon(Icons.add, color: IFridgeTheme.primary, size: 26),
              ),
            ),
            const SizedBox(height: 4),
            const Text('Add',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Story Avatar Ring ──

class _StoryAvatar extends StatelessWidget {
  final String name;
  final bool hasUnviewed;
  final bool isOwn;
  final int storyCount;
  final VoidCallback onTap;

  const _StoryAvatar({
    required this.name,
    required this.hasUnviewed,
    required this.isOwn,
    required this.storyCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          children: [
            // Avatar with gradient ring
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasUnviewed
                    ? const SweepGradient(
                        colors: [
                          IFridgeTheme.primary,
                          IFridgeTheme.secondary,
                          Color(0xFF00E5FF),
                          IFridgeTheme.primary,
                        ],
                      )
                    : null,
                border: hasUnviewed
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
              ),
              padding: const EdgeInsets.all(2.5),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.background,
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: hasUnviewed ? IFridgeTheme.primary : Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name.length > 8 ? '${name.substring(0, 7)}…' : name,
              style: TextStyle(
                color: hasUnviewed ? Colors.white : Colors.white54,
                fontSize: 11,
                fontWeight: hasUnviewed ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
