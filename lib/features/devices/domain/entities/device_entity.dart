import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  final String id;
  final String name;
  final String ipAddress;
  final String location;
  final bool isOnline;
  final DateTime lastPingTime;
  final double cpuUsage;
  final double memoryUsage;

  const DeviceEntity({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.location,
    required this.isOnline,
    required this.lastPingTime,
    required this.cpuUsage,
    required this.memoryUsage,
  });

  @override
  List<Object?> get props => [id, name, ipAddress, isOnline, lastPingTime];
}
