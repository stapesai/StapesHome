import 'package:hive/hive.dart';

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

  Future<List<T>> getBoxes<T>(String boxName) async {
    final openBox = await Hive.openBox<T>(boxName);
    return openBox.values.toList();
  }
}
