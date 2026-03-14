import 'package:equatable/equatable.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

class StartMonitoring extends DeviceEvent {}

class RefreshDevices extends DeviceEvent {}

class FilterDevices extends DeviceEvent {
  final String query;
  final bool? onlineStatus; // true for online, false for offline, null for all

  const FilterDevices(this.query, {this.onlineStatus});

  @override
  List<Object?> get props => [query, onlineStatus];
}
