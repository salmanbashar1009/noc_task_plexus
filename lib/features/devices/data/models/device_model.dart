import '../../domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.id,
    required super.name,
    required super.ipAddress,
    required super.location,
    required super.isOnline,
    required super.lastPingTime,
    required super.cpuUsage,
    required super.memoryUsage,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      ipAddress: json['ip_address'],
      location: json['location'],
      isOnline: json['is_online'] ?? false,
      lastPingTime: DateTime.parse(json['last_ping']),
      cpuUsage: (json['cpu_usage'] as num).toDouble(),
      memoryUsage: (json['memory_usage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ip_address': ipAddress,
      'location': location,
      'is_online': isOnline,
      'last_ping': lastPingTime.toIso8601String(),
      'cpu_usage': cpuUsage,
      'memory_usage': memoryUsage,
    };
  }
}
