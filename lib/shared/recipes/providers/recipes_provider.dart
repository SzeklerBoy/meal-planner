import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/error/failure.dart';
import 'package:meal_planner/shared/recipes/data/recipe_providers.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';

/// The recipe list shown on Home, exposed as an [AsyncValue]
/// (loading / data / error).
///
/// Retry: `ref.invalidate(recipesProvider)`.
/// Pull-to-refresh: `ref.refresh(recipesProvider.future)`.
final recipesProvider = FutureProvider<List<Recipe>>(
  (ref) => ref.watch(recipeRepositoryProvider).getRecipes(),
  retry: _retryTransientFailures,
);

Duration? _retryTransientFailures(int retryCount, Object error) {
  const maxRetries = 3;
  final isTransient = switch (error) {
    NetworkFailure() || TimeoutFailure() || ServerFailure() => true,
    _ => false,
  };
  if (!isTransient || retryCount >= maxRetries) return null;
  return Duration(seconds: 1 << retryCount);
}
