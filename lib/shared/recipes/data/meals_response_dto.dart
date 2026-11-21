import 'package:meal_planner/shared/recipes/data/meal_dto.dart';

/// The `{"meals": [...]}` wrapper returned by TheMealDB.
class MealsResponseDto {
  const MealsResponseDto(this.meals);

  final List<MealDto> meals;

  factory MealsResponseDto.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object');
    }

    final meals = json['meals'];
    if (meals == null) return const MealsResponseDto([]);
    if (meals is! List) {
      throw const FormatException('Expected "meals" to be a list');
    }

    return MealsResponseDto(
      meals.whereType<Map<String, dynamic>>().map(MealDto.fromJson).toList(),
    );
  }
}