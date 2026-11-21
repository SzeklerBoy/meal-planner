import 'package:meal_planner/shared/recipes/domain/ingredient.dart';

/// The app's own recipe model, independent of the API's JSON structure.
///
/// Favorite status is intentionally not stored here; it is user-specific
/// state handled separately.
class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    this.area,
    this.imageUrl,
    this.instructions,
    this.calories,
    this.tags = const [],
    this.ingredients = const [],
  });

  final String id;
  final String name;
  final String category;
  final String? area;
  final String? imageUrl;
  final String? instructions;
  final int? calories;
  final List<String> tags;
  final List<Ingredient> ingredients;
}
