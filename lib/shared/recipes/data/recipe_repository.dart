import 'package:dio/dio.dart';
import 'package:meal_planner/core/error/failure.dart';
import 'package:meal_planner/core/network/dio_error_mapper.dart';
import 'package:meal_planner/shared/recipes/data/meal_mapper.dart';
import 'package:meal_planner/shared/recipes/data/meals_response_dto.dart';
import 'package:meal_planner/shared/recipes/data/recipe_api_service.dart';
import 'package:meal_planner/shared/recipes/domain/recipe.dart';

/// The app's single access point to recipe data.
///
/// Screens and state never see DTOs or HTTP errors: this class returns
/// [Recipe]s and throws only [Failure]s. Cancelled requests are rethrown
/// as-is so callers can ignore them.
class RecipeRepository {
  RecipeRepository(this._api);

  final RecipeApiService _api;

  Future<List<Recipe>> getRecipes() {
    return _guard(() async => _toRecipes(await _api.searchMeals('')));
  }

  Future<List<Recipe>> searchRecipes(String query, {CancelToken? cancelToken}) {
    return _guard(
      () async => _toRecipes(
        await _api.searchMeals(query.trim(), cancelToken: cancelToken),
      ),
    );
  }

  Future<Recipe?> getRecipeById(String id) {
    return _guard(() async {
      final recipes = _toRecipes(await _api.lookupMeal(id));
      return recipes.isEmpty ? null : recipes.first;
    });
  }

  List<Recipe> _toRecipes(MealsResponseDto response) {
    final recipes = <Recipe>[];
    for (final meal in response.meals) {
      try {
        recipes.add(meal.toDomain());
      } on FormatException {
        continue;
      }
    }
    return recipes;
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw mapDioException(e);
    } on FormatException catch (e) {
      throw ParsingFailure(e.message);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e);
    }
  }
}
