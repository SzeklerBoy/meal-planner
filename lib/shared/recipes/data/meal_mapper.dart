import 'package:meal_planner/shared/recipes/data/meal_dto.dart';
import 'package:meal_planner/shared/recipes/domain/ingredient.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';

/// Converts the API's [MealDto] into the app's [Recipe].
///
/// If the API changes, only the DTO and this mapper need to change;
/// the screens keep using [Recipe].
extension MealDtoMapper on MealDto {
  static const String unnamedRecipe = 'Unnamed recipe';
  static const String defaultCategory = 'Other';

  Recipe toDomain() {
    final id = idMeal;
    if (id == null) {
      throw const FormatException('Meal is missing "idMeal"');
    }

    return Recipe(
      id: id,
      name: strMeal ?? unnamedRecipe,
      category: strCategory ?? defaultCategory,
      area: strArea,
      imageUrl: strMealThumb,
      instructions: strInstructions,
      tags: _parseTags(strTags),
      ingredients: [
        for (final ingredient in ingredients)
          Ingredient(name: ingredient.name, measure: ingredient.measure),
      ],
    );
  }

  static List<String> _parseTags(String? raw) {
    if (raw == null) return const [];
    return raw
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }
}
