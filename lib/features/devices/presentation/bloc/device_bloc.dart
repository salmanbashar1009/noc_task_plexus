import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository repository;
  final Map<String, bool> _previousOnlineStatus = {};

  DeviceBloc({required this.repository}) : super(DeviceInitial()) {
    on<StartMonitoring>(_onStartMonitoring);
    on<RefreshDevices>(_onRefreshDevices);
    on<FilterDevices>(_onFilterDevices);
  }

  List<DeviceEntity> _getNewOfflineDevices(List<DeviceEntity> devices) {
    List<DeviceEntity> alertDevices = [];
    for (final device in devices) {
      final wasOnline = _previousOnlineStatus[device.id] ?? true;
      if (!device.isOnline && wasOnline) {
        alertDevices.add(device);
      }
      _previousOnlineStatus[device.id] = device.isOnline;
    }
    
    // Cleanup old devices
    _previousOnlineStatus.removeWhere(
      (id, _) => devices.every((d) => d.id != id),
    );
    return alertDevices;
  }

  Future<void> _onStartMonitoring(
    StartMonitoring event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());
    _previousOnlineStatus.clear();

    final result = await repository.getDevices();
    result.fold(
      (failure) => emit(DeviceError(failure.message)),
      (devices) {
        final alertDevices = _getNewOfflineDevices(devices);
        emit(DeviceLoaded(devices, alertDevices: alertDevices));
      },
    );
  }

  Future<void> _onRefreshDevices(
    RefreshDevices event,
    Emitter<DeviceState> emit,
  ) async {
    final result = await repository.getDevices();
    result.fold(
      (failure) => emit(DeviceError(failure.message)),
      (devices) {
        final alertDevices = _getNewOfflineDevices(devices);
        emit(DeviceLoaded(devices, alertDevices: alertDevices));
      },
    );
  }

  void _onFilterDevices(FilterDevices event, Emitter<DeviceState> emit) {
    // Filter logic would go here
  }
}
