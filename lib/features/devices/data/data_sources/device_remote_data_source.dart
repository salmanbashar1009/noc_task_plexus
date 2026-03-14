import 'dart:async';
import 'dart:math';
import '../models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Stream<List<DeviceModel>> watchDevices();
  Future<List<DeviceModel>> getDevices();
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Random _random = Random();
  final _controller = StreamController<List<DeviceModel>>.broadcast();
  Timer? _timer;

  List<DeviceModel> _currentDevices = [];

  DeviceRemoteDataSourceImpl() {
    _initializeDevices();
    _startSimulation();
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

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateDevices();
      _controller.add(_currentDevices);
    });
  }

  @override
  Stream<List<DeviceModel>> watchDevices() async* {
    yield _currentDevices;
    yield* _controller.stream;
  }

  @override
  Future<List<DeviceModel>> getDevices() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentDevices;
  }

  void _updateDevices() {
    _currentDevices = _currentDevices.map((device) {
      // 20% chance of status change
      final bool statusChange = _random.nextInt(5) == 0;

      return DeviceModel(
        id: device.id,
        name: device.name,
        ipAddress: device.ipAddress,
        location: device.location,
        isOnline: statusChange ? !device.isOnline : device.isOnline,
        lastPingTime: DateTime.now(),
        cpuUsage: (_random.nextDouble() * 100).clamp(5.0, 98.0),
        memoryUsage: (_random.nextDouble() * 100).clamp(10.0, 95.0),
      );
    }).toList();
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

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
