import 'package:hive/hive.dart';
import 'sessions_model.dart';

class HiveService {
  Future<bool> isExists({required String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  Future<void> addBoxes<T>(List<T> items, String boxName) async {
    final openBox = await Hive.openBox<T>(boxName);
    for (var item in items) {
      await openBox.add(item);
    }
  }

  Future<void> addBox<T>(T item, String boxName) async {
    final openBox = await Hive.openBox<T>(boxName);
    await openBox.add(item);
  }

  Future<List<T>> getBoxes<T>(String boxName) async {
    final openBox = await Hive.openBox<T>(boxName);
    return openBox.values.toList();
  }

  Future<List<SessionsModel>> getSessionData() async {
    final openBox = await Hive.openBox<SessionsModel>('SessionBox');
    return openBox.values.toList();
  }

  Future<void> clearBox(String boxName) async {
    final openBox = await Hive.openBox(boxName);
    await openBox.clear();
  }
}
