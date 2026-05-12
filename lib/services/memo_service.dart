// lib/services/memo_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class MemoService {
  static const String memoPrefix = 'checkpoint_memo_';

  static Future<void> saveMemo(int pointId, String memo) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      '$memoPrefix$pointId',
      memo,
    );
  }

  static Future<String> loadMemo(int pointId) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
          '$memoPrefix$pointId',
        ) ??
        '';
  }

  static Future<void> deleteMemo(int pointId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      '$memoPrefix$pointId',
    );
  }
}