import 'package:shared_preferences/shared_preferences.dart';
import 'package:suma_education/suma_education/main_page/games/puzzle/src/domain/repositories/settings_repository.dart';

const darkModeKey = 'darkModeKey';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _preferences;

  SettingsRepositoryImpl(this._preferences);

  @override
  bool get isDarkMode => _preferences.getBool(darkModeKey) ?? false;

  @override
  Future<void> updateDarkMode(bool isDark) {
    return _preferences.setBool(darkModeKey, isDark);
  }
}
