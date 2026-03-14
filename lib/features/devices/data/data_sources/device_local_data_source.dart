import 'package:hive_flutter/hive_flutter.dart';
import '../models/device_model.dart';

abstract class DeviceLocalDataSource {
  Future<List<DeviceModel>> getCachedDevices();
  Future<void> cacheDevices(List<DeviceModel> devices);
}

class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final Box _box;

  DeviceLocalDataSourceImpl(this._box);

  @override
  Future<List<DeviceModel>> getCachedDevices() async {
    final data = _box.get('cached_devices', defaultValue: []);
    if (data is List) {
      return data
          .map((e) => DeviceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheDevices(List<DeviceModel> devices) async {
    final jsonList = devices.map((e) => e.toJson()).toList();
    await _box.put('cached_devices', jsonList);
  }
}
