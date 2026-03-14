import 'package:equatable/equatable.dart';
import '../../domain/entities/device_entity.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<DeviceEntity> devices;
  final DeviceEntity? alertDevice; // Used to trigger popups

  const DeviceLoaded(this.devices, {this.alertDevice});

  @override
  List<Object?> get props => [devices, alertDevice];
}

class DeviceError extends DeviceState {
  final String message;
  const DeviceError(this.message);
}
