import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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
    Directory dir = await getApplicationSupportDirectory();
    collection = await BoxCollection.open(
      AppConstants.dbDocuments.collection,
      {AppConstants.dbDocuments.defBox},
      path: dir.path,
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

  Future<dynamic> getValue({String? boxName, required String key}) async {
    final CollectionBox box =
        await collection.openBox(boxName ?? AppConstants.dbDocuments.defBox);
    return await box.get(key);
  }

  Future<void> deleteValue({String? boxName, required String key}) async {
    final CollectionBox box =
        await collection.openBox(boxName ?? AppConstants.dbDocuments.defBox);
    return box.delete(key);
  }
}
