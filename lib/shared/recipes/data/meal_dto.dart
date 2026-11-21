/// Raw meal record exactly as TheMealDB sends it.
///
/// Field names follow the API, every field is nullable, and no business
/// rules are applied here — that is the mapper's job.
class MealDto {
  const MealDto({
    this.idMeal,
    this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.ingredients = const [],
  });

  static const int _maxIngredients = 20;

  final String? idMeal;
  final String? strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final String? strTags;
  final List<({String name, String? measure})> ingredients;

  factory MealDto.fromJson(Map<String, dynamic> json) {
    final ingredients = <({String name, String? measure})>[];
    for (var i = 1; i <= _maxIngredients; i++) {
      final name = _readString(json['strIngredient$i']);
      if (name == null) continue;
      ingredients.add((name: name, measure: _readString(json['strMeasure$i'])));
    }

    return MealDto(
      idMeal: _readString(json['idMeal']),
      strMeal: _readString(json['strMeal']),
      strCategory: _readString(json['strCategory']),
      strArea: _readString(json['strArea']),
      strInstructions: _readString(json['strInstructions']),
      strMealThumb: _readString(json['strMealThumb']),
      strTags: _readString(json['strTags']),
      ingredients: ingredients,
    );
  }

  static String? _readString(Object? value) {
    final text = switch (value) {
      String s => s.trim(),
      num n => n.toString(),
      _ => null,
    };
    return (text == null || text.isEmpty) ? null : text;
  }
}
