import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_planner/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores the favorite recipe ids on the device, so they survive restarts.
///
/// A small list of ids is a good fit for SharedPreferences; the UI never
/// talks to SharedPreferences directly, only through this class.
class FavoritesRepository {
  FavoritesRepository(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const String _key = 'favorite_ids';

  Future<Set<String>> load() async {
    try {
      final ids = await _prefs.getStringList(_key);
      return ids?.toSet() ?? <String>{};
    } catch (e) {
      throw StorageFailure(e);
    }
  }

  Future<void> save(Set<String> ids) async {
    try {
      await _prefs.setStringList(_key, ids.toList());
    } catch (e) {
      throw StorageFailure(e);
    }
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(SharedPreferencesAsync()),
);
