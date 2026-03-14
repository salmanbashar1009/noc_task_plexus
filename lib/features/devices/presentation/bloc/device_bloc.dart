import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/device_repository.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository repository;
  StreamSubscription? _deviceSubscription;

  DeviceBloc({required this.repository}) : super(DeviceInitial()) {
    on<StartMonitoring>(_onStartMonitoring);
    on<FilterDevices>(_onFilterDevices);
  }

  Future<void> _onStartMonitoring(
    StartMonitoring event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());

    await _deviceSubscription?.cancel();

    _deviceSubscription = repository.watchDevices().listen((result) {
      result.fold((failure) => emit(DeviceError(failure.message)), (devices) {
        // Simple logic: if a device goes offline, pass it in state to trigger UI alert
        // In a real app, you'd compare with previous state to detect the *transition*
        final offlineDevice = devices.where((d) => !d.isOnline).firstOrNull;

        emit(DeviceLoaded(devices, alertDevice: offlineDevice));
      });
    });
  }

  void _onFilterDevices(FilterDevices event, Emitter<DeviceState> emit) {
    // Filter logic implementation would go here if we were managing list locally
    // For now, we keep it simple as the stream pushes data constantly.
  }

  @override
  Future<void> close() {
    _deviceSubscription?.cancel();
    return super.close();
  }
}
