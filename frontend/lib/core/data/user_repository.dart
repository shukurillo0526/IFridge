// I-Fridge — User Repository
// ============================
// Centralized data access for user-scoped resources:
// profile, gamification stats, flavor profile, shopping list, meal plan.
// All writes go through the backend API (service role).
// Dashboard read is a single backend call replacing 5 parallel queries.

import 'package:ifridge_app/core/services/api_service.dart';
import 'package:ifridge_app/core/services/auth_helper.dart';

class UserRepository {
  final ApiService _api = ApiService();

  // ── User Initialization ────────────────────────────────────

  /// Ensures user profile rows exist in the database.
  /// Safe to call multiple times (idempotent upsert).
  Future<void> ensureInitialized({
    required String userId,
    required String email,
    String? displayName,
  }) async {
    await _api.initUser(
      userId: userId,
      email: email,
      displayName: displayName,
    );
  }

  // ── Dashboard (single call replaces 5 parallel queries) ────

  /// Loads the complete user dashboard: profile, stats, flavor,
  /// shopping list, and meal plan in one API call.
  Future<Map<String, dynamic>> loadDashboard() async {
    return await _api.getUserDashboard(userId: currentUserId());
  }

  // ── Profile ────────────────────────────────────────────────

  /// Update the user's display name and/or dietary tags.
  Future<void> updateProfile({
    String? displayName,
    List<String>? dietaryTags,
    String? avatarUrl,
  }) async {
    await _api.updateUserProfile(
      userId: currentUserId(),
      displayName: displayName,
      dietaryTags: dietaryTags,
      avatarUrl: avatarUrl,
    );
  }

  // ── Shopping List ──────────────────────────────────────────

  /// Add an item to the shopping list.
  Future<Map<String, dynamic>> addShoppingItem({
    required String ingredientName,
    double quantity = 1.0,
    String unit = 'pcs',
  }) async {
    return await _api.addShoppingItem(
      userId: currentUserId(),
      ingredientName: ingredientName,
      quantity: quantity,
      unit: unit,
    );
  }

  /// Toggle a shopping list item's purchased status.
  Future<void> toggleShoppingItem({
    required String itemId,
    required bool isPurchased,
  }) async {
    await _api.toggleShoppingItem(
      itemId: itemId,
      isPurchased: isPurchased,
    );
  }

  /// Delete a shopping list item.
  Future<void> deleteShoppingItem(String itemId) async {
    await _api.deleteShoppingItem(itemId);
  }

  // ── Meal Plan ──────────────────────────────────────────────

  /// Plan a recipe for a specific date.
  Future<Map<String, dynamic>> addMealPlan({
    required String recipeId,
    required String plannedDate,
    String mealType = 'dinner',
  }) async {
    return await _api.addMealPlan(
      userId: currentUserId(),
      recipeId: recipeId,
      plannedDate: plannedDate,
      mealType: mealType,
    );
  }

  /// Remove a planned meal.
  Future<void> deleteMealPlan(String mealId) async {
    await _api.deleteMealPlan(mealId);
  }

  void dispose() {
    _api.dispose();
  }
}
