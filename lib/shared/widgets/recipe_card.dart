import 'package:flutter/material.dart';
import 'package:meal_planner/core/theme.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';
import 'package:meal_planner/shared/widgets/favorite_button.dart';
import 'package:meal_planner/shared/widgets/recipe_image.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({required this.recipe, this.onTap, super.key});

  final Recipe recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      recipe.category,
      if (recipe.area != null) recipe.area!,
    ].join(' · ');

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = (constraints.maxWidth * 0.45).clamp(140.0, 180.0);

        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: RecipeImage(recipe.imageUrl, height: imageHeight),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(recipeId: recipe.id),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                recipe.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.mutedTextColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
