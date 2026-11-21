import 'package:flutter/material.dart';
import 'package:meal_planner/core/theme.dart';

class Recipe {
  const Recipe({
    required this.imagePath,
    required this.title,
    required this.mealType,
    required this.duration,
    required this.energy,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servings,
    required this.ingredients,
  });

  final String imagePath;
  final String title;
  final String mealType;
  final String duration;
  final String energy;
  final String protein;
  final String carbs;
  final String fat;
  final int servings;
  final List<RecipeIngredient> ingredients;
}

class RecipeIngredient {
  const RecipeIngredient({required this.name, required this.amount});

  final String name;
  final String amount;
}

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
          Image.asset(recipe.imagePath, fit: BoxFit.cover),
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
                          recipe.title,
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
                    '${recipe.mealType} / ${recipe.duration}',
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
    final values = [
      ('${recipe.energy} kcal', 'Energy'),
      ('${recipe.protein} g', 'Protein'),
      ('${recipe.carbs} g', 'Carbs'),
      ('${recipe.fat} g', 'Fat'),
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

class _IngredientsSection extends StatefulWidget {
  const _IngredientsSection({required this.recipe});

  final Recipe recipe;

  @override
  State<_IngredientsSection> createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<_IngredientsSection> {
  late int servings = widget.recipe.servings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$servings servings',
                style: const TextStyle(
                  color: AppColors.mutedTextColor,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              _ServingButton(
                icon: Icons.remove,
                onPressed: servings > 1
                    ? () => setState(() => servings--)
                    : null,
              ),
              Container(width: 1, height: 20, color: AppColors.mutedTextColor),
              _ServingButton(
                icon: Icons.add,
                onPressed: () => setState(() => servings++),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.recipe.ingredients.map(
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
                    ingredient.amount,
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

class _ServingButton extends StatelessWidget {
  const _ServingButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 20,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 15),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 27, height: 20),
      ),
    );
  }
}
