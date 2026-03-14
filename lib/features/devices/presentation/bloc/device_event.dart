import 'package:equatable/equatable.dart';
import '../../domain/entities/device_entity.dart';

enum DeviceFilter { all, online, offline }

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

class StartMonitoring extends DeviceEvent {}

class UpdateDevices extends DeviceEvent {
  final List<DeviceEntity> devices;
  const UpdateDevices(this.devices);

  @override
  List<Object?> get props => [devices];
}

class RefreshDevices extends DeviceEvent {}

class FilterDevices extends DeviceEvent {
  final String? searchQuery;
  final DeviceFilter? filter;

  const FilterDevices({this.searchQuery, this.filter});

  @override
  List<Object?> get props => [searchQuery, filter];
}
