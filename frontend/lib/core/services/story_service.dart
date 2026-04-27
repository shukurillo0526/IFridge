// I-Fridge — Story Service
// ==========================
// Handles story CRUD, views tracking, and expiry logic.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ifridge_app/core/services/auth_helper.dart';

/// A single story item.
class StoryItem {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String mediaUrl;
  final String mediaType; // 'image' or 'video'
  final String? caption;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int viewCount;
  final bool isViewed;

  StoryItem({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.mediaUrl,
    this.mediaType = 'image',
    this.caption,
    required this.createdAt,
    required this.expiresAt,
    this.viewCount = 0,
    this.isViewed = false,
  });
}

/// A group of stories from one user.
class StoryGroup {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final List<StoryItem> stories;
  final bool hasUnviewed;
  final bool isOwn;

  StoryGroup({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.stories,
    required this.hasUnviewed,
    this.isOwn = false,
  });
}

class StoryService {
  static final _client = Supabase.instance.client;
  static final _picker = ImagePicker();

  /// Get all active stories grouped by user.
  /// Own stories first, then friends, then others.
  static Future<List<StoryGroup>> getStoryGroups() async {
    try {
      final uid = currentUserId();

      // Fetch active (non-expired) stories with author info
      final data = await _client
          .from('stories')
          .select('*, users!stories_author_id_fkey(display_name, avatar_url)')
          .gt('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);

      final stories = List<Map<String, dynamic>>.from(data);

      // Get viewed story IDs for current user
      final viewedData = await _client
          .from('story_views')
          .select('story_id')
          .eq('viewer_id', uid);
      final viewedIds = Set<String>.from(
        (viewedData as List).map((v) => v['story_id'] as String),
      );

      // Group by author
      final Map<String, List<StoryItem>> grouped = {};
      final Map<String, Map<String, dynamic>> authorInfo = {};

      for (final s in stories) {
        final authorId = s['author_id'] as String;
        final author = s['users'] as Map<String, dynamic>?;
        final storyId = s['id'] as String;

        authorInfo[authorId] = author ?? {};

        grouped.putIfAbsent(authorId, () => []);
        grouped[authorId]!.add(StoryItem(
          id: storyId,
          authorId: authorId,
          authorName: author?['display_name'] ?? 'User',
          authorAvatar: author?['avatar_url'] as String?,
          mediaUrl: s['media_url'] as String,
          mediaType: s['media_type'] as String? ?? 'image',
          caption: s['caption'] as String?,
          createdAt: DateTime.parse(s['created_at'] as String),
          expiresAt: DateTime.parse(s['expires_at'] as String),
          isViewed: viewedIds.contains(storyId),
        ));
      }

      // Build groups
      final groups = <StoryGroup>[];
      for (final entry in grouped.entries) {
        final userId = entry.key;
        final items = entry.value;
        final author = authorInfo[userId];
        final hasUnviewed = items.any((s) => !s.isViewed);

        groups.add(StoryGroup(
          userId: userId,
          userName: author?['display_name'] ?? 'User',
          avatarUrl: author?['avatar_url'] as String?,
          stories: items,
          hasUnviewed: hasUnviewed,
          isOwn: userId == uid,
        ));
      }

      // Sort: own first, then by hasUnviewed, then by most recent
      groups.sort((a, b) {
        if (a.isOwn) return -1;
        if (b.isOwn) return 1;
        if (a.hasUnviewed && !b.hasUnviewed) return -1;
        if (!a.hasUnviewed && b.hasUnviewed) return 1;
        return b.stories.first.createdAt.compareTo(a.stories.first.createdAt);
      });

      return groups;
    } catch (e) {
      debugPrint('[Story] getStoryGroups error: $e');
      return [];
    }
  }

  /// Create a new story.
  static Future<bool> createStory({
    required String mediaUrl,
    String mediaType = 'image',
    String? caption,
  }) async {
    try {
      await _client.from('stories').insert({
        'author_id': currentUserId(),
        'media_url': mediaUrl,
        'media_type': mediaType,
        'caption': caption,
      });
      return true;
    } catch (e) {
      debugPrint('[Story] createStory error: $e');
      return false;
    }
  }

  /// Mark a story as viewed.
  static Future<void> markViewed(String storyId) async {
    try {
      await _client.from('story_views').upsert({
        'story_id': storyId,
        'viewer_id': currentUserId(),
      });
    } catch (e) {
      debugPrint('[Story] markViewed error: $e');
    }
  }

  /// Upload story media (image from camera/gallery).
  static Future<String?> uploadStoryMedia(XFile file) async {
    try {
      final uid = currentUserId();
      final ext = file.path.split('.').last;
      final path = 'stories/$uid/${DateTime.now().millisecondsSinceEpoch}.$ext';

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        await _client.storage
            .from('post-media')
            .uploadBinary(path, bytes, fileOptions: FileOptions(contentType: 'image/$ext'));
      } else {
        await _client.storage
            .from('post-media')
            .upload(path, File(file.path));
      }

      return _client.storage.from('post-media').getPublicUrl(path);
    } catch (e) {
      debugPrint('[Story] uploadStoryMedia error: $e');
      return null;
    }
  }

  /// Pick image for story.
  static Future<XFile?> pickStoryImage({ImageSource source = ImageSource.camera}) async {
    try {
      return await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 85,
      );
    } catch (e) {
      debugPrint('[Story] pickStoryImage error: $e');
      return null;
    }
  }

  /// Delete own story.
  static Future<void> deleteStory(String storyId) async {
    try {
      await _client.from('stories').delete().eq('id', storyId);
    } catch (e) {
      debugPrint('[Story] deleteStory error: $e');
    }
  }
}
