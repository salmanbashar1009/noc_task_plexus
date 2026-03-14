import 'dart:async';
import 'dart:math';
import '../models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Stream<List<DeviceModel>> watchDevices();
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Random _random = Random();

  List<DeviceModel> _currentDevices = [];

  DeviceRemoteDataSourceImpl() {
    _initializeDevices();
  }

  void _initializeDevices() {
    _currentDevices = List.generate(10, (index) {
      return DeviceModel(
        id: 'dev_$index',
        name: _getDeviceName(index),
        ipAddress: '192.168.1.${10 + index}',
        location: _getLocation(index),
        isOnline: index != 5, // One device offline initially
        lastPingTime: DateTime.now(),
        cpuUsage: 20.0 + _random.nextDouble() * 30,
        memoryUsage: 40.0 + _random.nextDouble() * 20,
      );
    });
  }

  @override
  Stream<List<DeviceModel>> watchDevices() {
    // Simulate real-time updates every 3 seconds
    return Stream.periodic(const Duration(seconds: 10), (_) {
      return _updateDevices();
    });
  }

  List<DeviceModel> _updateDevices() {
    // Simulate random status changes and usage spikes
    _currentDevices = _currentDevices.map((device) {
      final bool goOffline = _random.nextInt(10) == 0;

      return DeviceModel(
        id: device.id,
        name: device.name,
        ipAddress: device.ipAddress,
        location: device.location,
        isOnline: goOffline ? !device.isOnline : device.isOnline,
        lastPingTime: DateTime.now(),
        cpuUsage: (_random.nextDouble() * 100).clamp(5.0, 98.0),
        memoryUsage: (_random.nextDouble() * 100).clamp(10.0, 95.0),
      );
    }).toList();

    return _currentDevices;
  }

  String _getDeviceName(int index) {
    const types = ['Router', 'Switch', 'Firewall', 'Server', 'AP'];
    return '${types[index % types.length]} ${index + 1}';
  }

  String _getLocation(int index) {
    const locs = [
      'NYC Datacenter',
      'London Office',
      'Dhaka Branch',
      'Tokyo Hub',
    ];
    return locs[index % locs.length];
  }
}
