import 'package:hive/hive.dart';
import 'sessions_model.dart';

class HiveService {
  final Map<String, Box> _openBoxes = {};

  Future<Box<T>> _openBox<T>(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      return _openBoxes[boxName] as Box<T>;
    } else {
      final box = await Hive.openBox<T>(boxName);
      _openBoxes[boxName] = box;
      return box;
    }
  }

  Future<void> _closeBox(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      await _openBoxes[boxName]!.close();
      _openBoxes.remove(boxName);
    }
  }

  Future<bool> isExists({required String boxName}) async {
    final box = await _openBox(boxName);
    bool exists = box.length != 0;
    await _closeBox(boxName);
    return exists;
  }

  Future<void> addBoxes<T>(List<T> items, String boxName) async {
    final box = await _openBox<T>(boxName);
    for (var item in items) {
      await box.add(item);
    }
    await _closeBox(boxName);
  }

  Future<void> addBox<T>(T item, String boxName) async {
    final box = await _openBox<T>(boxName);
    await box.add(item);
    await _closeBox(boxName);
  }

  Future<List<T>> getBoxes<T>(String boxName) async {
    final box = await _openBox<T>(boxName);
    List<T> result = box.values.toList();
    await _closeBox(boxName);
    return result;
  }

  Future<List<SessionsModel>> getSessionData() async {
    final box = await _openBox<SessionsModel>('SessionBox');
    List<SessionsModel> result = box.values.toList();
    await _closeBox('SessionBox');
    return result;
  }

  Future<void> clearBox(String boxName) async {
    await _closeBox(boxName); // Ensure the box is closed first
    await Hive.deleteBoxFromDisk(boxName);
    _openBoxes.remove(boxName); // Remove from our tracking map
  }

  // Call this method when your app is closing or you want to ensure all boxes are closed
  Future<void> closeAllBoxes() async {
    for (var boxName in _openBoxes.keys) {
      await _openBoxes[boxName]!.close();
    }
    _openBoxes.clear();
  }
}
