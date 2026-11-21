import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';
import 'package:meal_planner/shared/recipes/providers/recipes_provider.dart';

/// The single source of truth for favorites: a set of recipe ids.
///
/// Every heart (Home card, details, Favorites screen) reads this state,
/// so they always show the same value. Kept in memory only for now.
class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void toggle(String recipeId) {
    // Always assign a new Set so Riverpod notices the change.
    state = state.contains(recipeId)
        ? ({...state}..remove(recipeId))
        : {...state, recipeId};
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

/// Each heart watches only its own recipe, so toggling one heart
/// doesn't rebuild every card.
final isFavoriteProvider = Provider.family<bool, String>(
  (ref, recipeId) => ref.watch(favoritesProvider).contains(recipeId),
);

/// The loaded recipes filtered by the favorite ids.
final favoriteRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final ids = ref.watch(favoritesProvider);
  return ref
      .watch(recipesProvider)
      .whenData((recipes) => recipes.where((r) => ids.contains(r.id)).toList());
});
