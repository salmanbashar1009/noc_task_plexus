import 'dart:async';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository repository;
  StreamSubscription? _deviceSubscription;
  Timer? _reloadTimer;
  final Map<String, bool> _previousOnlineStatus = {};

  DeviceBloc({required this.repository}) : super(DeviceInitial()) {
    on<StartMonitoring>(_onStartMonitoring);
    on<RefreshDevices>(_onRefreshDevices);
    on<FilterDevices>(_onFilterDevices);
  }

  DeviceEntity? _getNewOfflineDevice(List<DeviceEntity> devices) {
    DeviceEntity? alertDevice;
    for (final device in devices) {
      final wasOnline = _previousOnlineStatus[device.id] ?? true;
      if (!device.isOnline && wasOnline) {
        alertDevice = device;
        break; // first newly offline
      }
    }
    // Update status
    for (final device in devices) {
      _previousOnlineStatus[device.id] = device.isOnline;
    }
    // Cleanup old devices
    _previousOnlineStatus.removeWhere(
      (id, _) => devices.every((d) => d.id != id),
    );
    return alertDevice;
  }

  Future<void> _onStartMonitoring(
    StartMonitoring event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());

    await _deviceSubscription?.cancel();
    _reloadTimer?.cancel();
    _previousOnlineStatus.clear();

    // Load initial data
    final initialResult = await repository.getDevices();
    initialResult.fold(
      (failure) {
        if (!emit.isDone) emit(DeviceError(failure.message));
      },
      (devices) {
        final alertDevice = _getNewOfflineDevice(devices);
        if (!emit.isDone) {
          emit(DeviceLoaded(devices, alertDevice: alertDevice));
        }
      },
    );

    // Live updates stream
    _deviceSubscription = repository.watchDevices().listen((result) {
      if (emit.isDone) return;
      result.fold(
        (failure) {
          if (!emit.isDone) emit(DeviceError(failure.message));
        },
        (devices) {
          final alertDevice = _getNewOfflineDevice(devices);
          if (!emit.isDone) {
            emit(DeviceLoaded(devices, alertDevice: alertDevice));
          }
        },
      );
    });

    // Auto reload every 30s
    _reloadTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      add(RefreshDevices());
    });
  }

  Future<void> _onRefreshDevices(
    RefreshDevices event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());

    final result = await repository.getDevices();
    result.fold((failure) => emit(DeviceError(failure.message)), (devices) {
      final alertDevice = _getNewOfflineDevice(devices);
      emit(DeviceLoaded(devices, alertDevice: alertDevice));
    });
  }

  void _onFilterDevices(FilterDevices event, Emitter<DeviceState> emit) {
    // Filter logic would go here
  }

  @override
  Future<void> close() {
    _deviceSubscription?.cancel();
    _reloadTimer?.cancel();
    return super.close();
  }
}
