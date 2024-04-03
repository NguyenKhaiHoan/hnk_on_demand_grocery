import 'package:get_storage/get_storage.dart';

class HLocalService {
  HLocalService._internal();

  static HLocalService? _instance;

  late final GetStorage _storage;

  factory HLocalService.instance() {
    _instance ??= HLocalService._internal();
    return _instance!;
  }

  static Future<void> initializeStorage(String id) async {
    await GetStorage.init(id);
    _instance = HLocalService._internal();
    _instance!._storage = GetStorage(id);
  }

  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  T? getData<T>(String key) {
    return _storage.read<T>(key);
  }

  Future<void> deleteData(String key) async {
    await _storage.remove(key);
  }
}
