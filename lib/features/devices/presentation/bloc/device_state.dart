import 'package:equatable/equatable.dart';
import '../../domain/entities/device_entity.dart';
import 'device_event.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<DeviceEntity> devices;
  final List<DeviceEntity> alertDevices;
  final List<DeviceEntity> filteredDevices;
  final String searchQuery;
  final DeviceFilter currentFilter;

  const DeviceLoaded(
    this.devices, {
    this.alertDevices = const [],
    this.filteredDevices = const [],
    this.searchQuery = '',
    this.currentFilter = DeviceFilter.all,
  });

  @override
  List<Object?> get props => [devices, alertDevices, filteredDevices, searchQuery, currentFilter];
}

class DeviceError extends DeviceState {
  final String message;
  const DeviceError(this.message);
}
