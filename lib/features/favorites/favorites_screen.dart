import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/theme.dart';
import 'package:meal_planner/features/recipe_details/recipe_details_screen.dart';
import 'package:meal_planner/shared/favorites/favorites_provider.dart';
import 'package:meal_planner/shared/recipes/providers/recipes_provider.dart';
import 'package:meal_planner/shared/widgets/recipe_card.dart';
import 'package:meal_planner/shared/widgets/state_views.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteRecipesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
        title: const Text(
          'Favorites',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: favoritesAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: failureMessage(error),
          onRetry: () => ref.invalidate(recipesProvider),
        ),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const EmptyView(
              icon: Icons.favorite_border,
              message:
                  'No favorites yet.\nTap the heart on a recipe to save it.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: recipes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(
                recipe: recipe,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailsScreen(recipe: recipe),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
