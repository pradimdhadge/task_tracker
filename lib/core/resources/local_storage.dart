import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_tracker/core/resources/secure_storage_helper.dart';

import '../constants/constants.dart';

class LocalStorage {
  static LocalStorage? _i;
  LocalStorage._();
  factory LocalStorage() {
    return _i ??
        (throw "LocalStorage is not initialized. Please call LocalStorage.init()");
  }

  static late final BoxCollection collection;

  static Future<void> init() async {
    if (_i != null) {
      return;
    }

    FlutterSecureStorage storage = SecureStorageHelper.storage;
    String? dbKey = await storage.read(key: AppConstants.dbDocuments.hiveDbKey);
    if (dbKey == null) {
      dbKey =
          String.fromCharCodes(Uint8List.fromList(Hive.generateSecureKey()));
      storage.write(key: AppConstants.dbDocuments.hiveDbKey, value: dbKey);
    }

    List<int> chiper = dbKey.codeUnits;

    Directory dir = await getApplicationSupportDirectory();
    collection = await BoxCollection.open(
      AppConstants.dbDocuments.collection,
      path: dir.path,
      key: HiveAesCipher(chiper),
      {
        AppConstants.dbDocuments.defBox,
        AppConstants.dbDocuments.taskBox,
        AppConstants.dbDocuments.taskTimerBox,
      },
    );
    _i = LocalStorage._();
  }

  Future<CollectionBox<dynamic>> openBox(String boxName) async {
    return await collection.openBox(boxName);
  }

  Future<void> putValue({
    required String key,
    required dynamic value,
    String? boxName,
  }) async {
    final CollectionBox box =
        await collection.openBox(boxName ?? AppConstants.dbDocuments.defBox);
    await box.put(key, value);
  }

  Future<void> updateValue({
    required String key,
    required dynamic value,
    String? boxName,
  }) async {
    final CollectionBox box =
        await collection.openBox(boxName ?? AppConstants.dbDocuments.defBox);
    await box.delete(key);
    await box.put(key, value);
  }

  Future<dynamic> getValue({String? boxName, required String key}) async {
    final CollectionBox box =
        await collection.openBox(boxName ?? AppConstants.dbDocuments.defBox);
    return await box.get(key);
  }

  Future<Map<String, dynamic>> getAllValue({String? boxName}) async {
    final CollectionBox box =
        await collection.openBox(boxName ?? AppConstants.dbDocuments.defBox);
    return await box.getAllValues();
  }

  Future<void> deleteValue({String? boxName, required String key}) async {
    final CollectionBox box =
        await collection.openBox(boxName ?? AppConstants.dbDocuments.defBox);
    return box.delete(key);
  }
}
