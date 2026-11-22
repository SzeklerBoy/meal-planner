/// Central configuration of TheMealDB REST API.
///
/// Docs: https://www.themealdb.com/api.php
/// `1` is the free public test key.
///
/// Endpoints used by the app (relative to [baseUrl]):
/// - `search.php?s={query}` – search meals by name (empty query = list)
/// - `lookup.php?i={id}`    – full details of one meal
/// - `categories.php`       – all meal categories
/// - `filter.php?c={name}`  – meals in a category
abstract final class ApiConfig {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
