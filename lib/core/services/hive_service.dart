import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _secureBoxName = 'secureBox';
  static const String _jwtTokenKey = 'jwt_token';

  Future<Box<T>> getOpenBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      debugPrint(
        '[HiveService] WARNING: Box "$boxName" was not open. Attempting to open now. This should have been done in bootstrap.',
      );
      try {
        return await Hive.openBox<T>(boxName);
      } catch (e) {
        debugPrint(
          '[HiveService] CRITICAL ERROR: Failed to open box "$boxName" on demand: $e',
        );
        throw HiveError('Box "$boxName" could not be opened.');
      }
    }
    return Hive.box<T>(boxName);
  }

  Future<String?> getAuthToken() async {
    try {
      final box = await getOpenBox<String>(_secureBoxName);
      final token = box.get(_jwtTokenKey);
      debugPrint(
        '[HiveService] GET from "$_secureBoxName" | key: "$_jwtTokenKey" | token found: ${token != null && token.isNotEmpty}',
      );
      return token;
    } catch (e) {
      debugPrint(
        '[HiveService] ERROR GET from "$_secureBoxName" | key: "$_jwtTokenKey" | Error: $e',
      );
      return null;
    }
  }

  Future<void> setAuthToken(String token) async {
    try {
      final box = await getOpenBox<String>(_secureBoxName);
      await box.put(_jwtTokenKey, token);
      debugPrint(
        '[HiveService] PUT to "$_secureBoxName" | key: "$_jwtTokenKey" | token set.',
      );
    } catch (e) {
      debugPrint(
        '[HiveService] ERROR PUT to "$_secureBoxName" | key: "$_jwtTokenKey" | Error: $e',
      );
    }
  }

  Future<void> deleteAuthToken() async {
    try {
      final box = await getOpenBox<String>(_secureBoxName);
      await box.delete(_jwtTokenKey);
      debugPrint(
        '[HiveService] DELETE from "$_secureBoxName" | key: "$_jwtTokenKey"',
      );
    } catch (e) {
      debugPrint(
        '[HiveService] ERROR DELETE from "$_secureBoxName" | key: "$_jwtTokenKey" | Error: $e',
      );
    }
  }

  Future<T?> get<T>(String boxName, dynamic key) async {
    try {
      final box = await getOpenBox<T>(boxName);
      final value = box.get(key);
      debugPrint(
        '[HiveService] GET from "$boxName" | key: "$key" | value: ${value != null ? value.toString().substring(0, (value.toString().length > 100 ? 100 : value.toString().length)) : 'null'}...',
      );
      return value;
    } catch (e) {
      debugPrint(
        '[HiveService] ERROR GET from "$boxName" | key: "$key" | Error: $e',
      );
      return null;
    }
  }

  Future<void> put<T>(String boxName, dynamic key, T value) async {
    try {
      final box = await getOpenBox<T>(boxName);
      await box.put(key, value);
      debugPrint(
        '[HiveService] PUT to "$boxName" | key: "$key" | value: ${value.toString().substring(0, (value.toString().length > 100 ? 100 : value.toString().length))}...',
      );
    } catch (e) {
      debugPrint(
        '[HiveService] ERROR PUT to "$boxName" | key: "$key" | Error: $e',
      );
    }
  }

  Future<void> delete(String boxName, dynamic key) async {
    try {
      final box = await getOpenBox<dynamic>(boxName);
      await box.delete(key);
      debugPrint('[HiveService] DELETE from "$boxName" | key: "$key"');
    } catch (e) {
      debugPrint(
        '[HiveService] ERROR DELETE from "$boxName" | key: "$key" | Error: $e',
      );
    }
  }

  Future<void> clearBox(String boxName) async {
    try {
      final box = await getOpenBox<dynamic>(boxName);
      final count = await box.clear();
      debugPrint(
        '[HiveService] CLEARED box "$boxName" | $count items removed.',
      );
    } catch (e) {
      debugPrint('[HiveService] ERROR CLEARING box "$boxName" | Error: $e');
    }
  }

  Map<dynamic, T> getBoxEntries<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      debugPrint(
        '[HiveService] WARNING: getBoxEntries called on unopened box "$boxName". Returning empty map.',
      );
      return {};
    }
    final box = Hive.box<T>(boxName);
    debugPrint(
      '[HiveService] GET ALL ENTRIES from "$boxName" | count: ${box.length}',
    );
    return box.toMap();
  }

  Future<String?> getJsonString(String boxName, dynamic key) async {
    return get<String>(boxName, key);
  }

  Future<void> putJsonString(
    String boxName,
    dynamic key,
    String jsonString,
  ) async {
    return put<String>(boxName, key, jsonString);
  }

  Future<List<T>> getListFromJsonStringKey<T>(
    String boxName,
    String listKey,
    T Function(Map<String, dynamic> json) fromJsonFactory,
  ) async {
    await getOpenBox<String>(boxName);
    final listJson = await getJsonString(boxName, listKey);
    if (listJson != null && listJson.isNotEmpty) {
      try {
        final decodedList = json.decode(listJson) as List<dynamic>;
        debugPrint(
          '[HiveService] GET LIST from "$boxName" | key: "$listKey" | count: ${decodedList.length}',
        );
        return decodedList
            .map(
              (jsonItem) => fromJsonFactory(jsonItem as Map<String, dynamic>),
            )
            .toList();
      } catch (e) {
        debugPrint(
          '[HiveService] Error deserializing list from "$boxName" key "$listKey": $e. Corrupted data?',
        );
        await delete(boxName, listKey);
        return [];
      }
    }
    return [];
  }

  Future<void> putListAsJsonStringKey<T>(
    String boxName,
    String listKey,
    List<T> list,
    Map<String, dynamic> Function(T item) toJsonFactory,
  ) async {
    await getOpenBox<String>(boxName);
    final jsonList = list.map((item) => toJsonFactory(item)).toList();
    await putJsonString(boxName, listKey, json.encode(jsonList));
    debugPrint(
      '[HiveService] PUT LIST to "$boxName" | key: "$listKey" | count: ${list.length}',
    );
  }
}
