// I-Fridge — Business Account Service
// =====================================
// Manages restaurant/business accounts for Order mode content.
// Only verified businesses can post in Order feeds.

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ifridge_app/core/services/auth_helper.dart';

class BusinessAccount {
  final String id;
  final String userId;
  final String businessName;
  final String businessType;
  final bool isVerified;
  final String? logoUrl;
  final String? coverUrl;
  final String? description;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;

  BusinessAccount({
    required this.id,
    required this.userId,
    required this.businessName,
    this.businessType = 'restaurant',
    this.isVerified = false,
    this.logoUrl,
    this.coverUrl,
    this.description,
    this.locationName,
    this.locationLat,
    this.locationLng,
  });

  factory BusinessAccount.fromMap(Map<String, dynamic> map) => BusinessAccount(
    id: map['id'] as String,
    userId: map['user_id'] as String,
    businessName: map['business_name'] as String,
    businessType: map['business_type'] as String? ?? 'restaurant',
    isVerified: map['is_verified'] as bool? ?? false,
    logoUrl: map['logo_url'] as String?,
    coverUrl: map['cover_url'] as String?,
    description: map['description'] as String?,
    locationName: map['location_name'] as String?,
    locationLat: (map['location_lat'] as num?)?.toDouble(),
    locationLng: (map['location_lng'] as num?)?.toDouble(),
  );
}

class BusinessService {
  static final _client = Supabase.instance.client;

  /// Get the current user's business account (if any).
  static Future<BusinessAccount?> getMyBusiness() async {
    try {
      final uid = currentUserId();
      final data = await _client
          .from('business_accounts')
          .select()
          .eq('user_id', uid)
          .maybeSingle();
      if (data == null) return null;
      return BusinessAccount.fromMap(data);
    } catch (e) {
      debugPrint('[Business] getMyBusiness error: $e');
      return null;
    }
  }

  /// Check if current user has a business account.
  static Future<bool> isBusiness() async {
    final biz = await getMyBusiness();
    return biz != null;
  }

  /// Register a new business account.
  static Future<BusinessAccount?> registerBusiness({
    required String businessName,
    String businessType = 'restaurant',
    String? description,
    String? locationName,
    double? locationLat,
    double? locationLng,
  }) async {
    try {
      final uid = currentUserId();
      final data = await _client.from('business_accounts').insert({
        'user_id': uid,
        'business_name': businessName,
        'business_type': businessType,
        'description': description,
        'location_name': locationName,
        'location_lat': locationLat,
        'location_lng': locationLng,
      }).select().single();
      return BusinessAccount.fromMap(data);
    } catch (e) {
      debugPrint('[Business] registerBusiness error: $e');
      return null;
    }
  }

  /// Update business account.
  static Future<bool> updateBusiness({
    required String id,
    String? businessName,
    String? description,
    String? logoUrl,
    String? coverUrl,
    String? locationName,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (businessName != null) updates['business_name'] = businessName;
      if (description != null) updates['description'] = description;
      if (logoUrl != null) updates['logo_url'] = logoUrl;
      if (coverUrl != null) updates['cover_url'] = coverUrl;
      if (locationName != null) updates['location_name'] = locationName;

      await _client.from('business_accounts').update(updates).eq('id', id);
      return true;
    } catch (e) {
      debugPrint('[Business] updateBusiness error: $e');
      return false;
    }
  }

  /// Get business stats (post count, total views, total likes).
  static Future<Map<String, int>> getBusinessStats(String userId) async {
    try {
      final posts = await _client
          .from('posts')
          .select('id, like_count, view_count')
          .eq('author_id', userId)
          .eq('post_type', 'reel');

      int totalViews = 0, totalLikes = 0;
      for (final p in (posts as List)) {
        totalViews += (p['view_count'] as int?) ?? 0;
        totalLikes += (p['like_count'] as int?) ?? 0;
      }

      return {
        'posts': (posts as List).length,
        'views': totalViews,
        'likes': totalLikes,
      };
    } catch (e) {
      debugPrint('[Business] getBusinessStats error: $e');
      return {'posts': 0, 'views': 0, 'likes': 0};
    }
  }
}
