import 'package:flutter/material.dart';
import 'package:meal_planner/core/theme.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';
import 'package:meal_planner/shared/widgets/recipe_image.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({required this.recipe, super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _RecipeHero(recipe: recipe),
              _RecipeSheet(recipe: recipe),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeHero extends StatelessWidget {
  const _RecipeHero({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final heroHeight = (MediaQuery.sizeOf(context).width * 0.78).clamp(
      280.0,
      380.0,
    );

    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RecipeImage(recipe.imageUrl, fit: BoxFit.cover),
          Positioned(
            top: 12,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeroButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const _HeroButton(icon: Icons.more_horiz),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.textColor, size: 25),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      splashRadius: 20,
    );
  }
}

class _RecipeSheet extends StatelessWidget {
  const _RecipeSheet({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 15, 24, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 28,
                          height: 28,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          recipe.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 28),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      recipe.category,
                      if (recipe.area != null) recipe.area!,
                    ].join(' / '),
                    style: const TextStyle(
                      color: AppColors.mutedTextColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            _NutritionSummary(recipe: recipe),
            _IngredientsSection(recipe: recipe),
            _InstructionsSection(recipe: recipe),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.backgroundColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Start cooking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  const _NutritionSummary({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final calories = recipe.calories;
    final values = [
      (calories == null ? 'Not available' : '$calories kcal', 'Energy'),
      (recipe.category, 'Category'),
      (recipe.area ?? '–', 'Cuisine'),
      ('${recipe.ingredients.length}', 'Ingredients'),
    ];

    return Container(
      color: AppColors.motivationalBackgroundColor,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: values
            .map(
              (value) => Expanded(
                child: Column(
                  children: [
                    Text(
                      value.$1,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value.$2,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  const _IngredientsSection({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final count = recipe.ingredients.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _SectionTitle('Ingredients'),
              const SizedBox(width: 8),
              Text(
                '$count ${count == 1 ? 'ingredient' : 'ingredients'}',
                style: const TextStyle(
                  color: AppColors.mutedTextColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recipe.ingredients.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      ingredient.name,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    ingredient.measure ?? '',
                    style: const TextStyle(
                      color: AppColors.mutedTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionsSection extends StatelessWidget {
  const _InstructionsSection({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle('Instructions'),
          const SizedBox(height: 8),
          Text(
            recipe.instructions ?? 'No instructions available.',
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
