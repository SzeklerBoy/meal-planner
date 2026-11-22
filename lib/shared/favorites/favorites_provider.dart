import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/error/failure.dart';
import 'package:meal_planner/shared/favorites/favorites_repository.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';
import 'package:meal_planner/shared/recipes/providers/recipes_provider.dart';

/// The in-memory favorites state: a set of recipe ids.
///
/// Every heart (Home card, details, Favorites screen) reads this state, so
/// they always show the same value. It is loaded from and saved to the
/// device through [FavoritesRepository], which is the persistent source.
class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() => ref.watch(favoritesRepositoryProvider).load();

  /// Optimistic update: the heart changes immediately, then the new set is
  /// saved. If saving fails, the previous state is restored and the
  /// [Failure] is rethrown so the UI can show feedback.
  Future<void> toggle(String recipeId) async {
    final previous = await future;
    final next = previous.contains(recipeId)
        ? ({...previous}..remove(recipeId))
        : {...previous, recipeId};
    state = AsyncData(next);

    try {
      await ref.read(favoritesRepositoryProvider).save(next);
    } on Failure {
      // Only roll back if no newer toggle has replaced the state meanwhile.
      if (identical(state.value, next)) state = AsyncData(previous);
      rethrow;
    }
  }
}

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
  // Retrying local storage won't help, so skip Riverpod's automatic retry.
  retry: (_, _) => null,
);

/// Each heart watches only its own recipe, so toggling one heart
/// doesn't rebuild every card. Shows "not favorite" while loading.
final isFavoriteProvider = Provider.family<bool, String>(
  (ref, recipeId) =>
      ref.watch(favoritesProvider).value?.contains(recipeId) ?? false,
);

/// The loaded recipes filtered by the favorite ids.
final favoriteRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  final recipes = ref.watch(recipesProvider);

  return switch (favorites) {
    AsyncData(value: final ids) => recipes.whenData(
      (list) => list.where((r) => ids.contains(r.id)).toList(),
    ),
    AsyncError(:final error, :final stackTrace) => AsyncError(
      error,
      stackTrace,
    ),
    _ => const AsyncLoading(),
  };
});
