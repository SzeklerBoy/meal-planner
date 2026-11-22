import 'package:dio/dio.dart';
import 'package:meal_planner/shared/recipes/data/meals_response_dto.dart';

/// Talks to TheMealDB over HTTP: knows the endpoints and their parameters.
///
/// Returns raw DTOs and only throws technical errors
/// ([DioException], [FormatException]); turning them into app-level
/// errors is the repository's job.
class RecipeApiService {
  RecipeApiService(this._dio);

  final Dio _dio;

  Future<MealsResponseDto> searchMeals(
    String query, {
    CancelToken? cancelToken,
  }) {
    return _getMeals('search.php', {'s': query}, cancelToken);
  }

  Future<MealsResponseDto> lookupMeal(String id, {CancelToken? cancelToken}) {
    return _getMeals('lookup.php', {'i': id}, cancelToken);
  }

  Future<MealsResponseDto> _getMeals(
    String path,
    Map<String, dynamic> queryParameters,
    CancelToken? cancelToken,
  ) async {
    final response = await _dio.get<Object?>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return MealsResponseDto.fromJson(response.data);
  }
}
