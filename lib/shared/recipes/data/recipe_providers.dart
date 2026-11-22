import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/network/dio_client.dart';
import 'package:meal_planner/shared/recipes/data/recipe_api_service.dart';
import 'package:meal_planner/shared/recipes/data/recipe_repository.dart';

final recipeApiServiceProvider = Provider<RecipeApiService>(
  (ref) => RecipeApiService(ref.watch(dioProvider)),
);

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepository(ref.watch(recipeApiServiceProvider)),
);
