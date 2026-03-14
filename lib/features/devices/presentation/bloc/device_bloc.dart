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
    
    _previousOnlineStatus.removeWhere(
      (id, _) => devices.every((d) => d.id != id),
    );
    return alertDevices;
  }

  List<DeviceEntity> _getFilteredDevices(
    List<DeviceEntity> devices,
    String query,
    DeviceFilter filter,
  ) {
    return devices.where((d) {
      final matchesSearch = d.name.toLowerCase().contains(query.toLowerCase());
      bool matchesFilter = true;
      if (filter == DeviceFilter.online) {
        matchesFilter = d.isOnline;
      } else if (filter == DeviceFilter.offline) {
        matchesFilter = !d.isOnline;
      }
      return matchesSearch && matchesFilter;
    }).toList();
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
        emit(DeviceLoaded(
          devices,
          alertDevices: alertDevices,
          filteredDevices: devices,
        ));
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
        
        String query = '';
        DeviceFilter filter = DeviceFilter.all;
        
        if (state is DeviceLoaded) {
          final s = state as DeviceLoaded;
          query = s.searchQuery;
          filter = s.currentFilter;
        }

        final filtered = _getFilteredDevices(devices, query, filter);

        emit(DeviceLoaded(
          devices,
          alertDevices: alertDevices,
          filteredDevices: filtered,
          searchQuery: query,
          currentFilter: filter,
        ));
      },
    );
  }

  void _onFilterDevices(FilterDevices event, Emitter<DeviceState> emit) {
    if (state is DeviceLoaded) {
      final s = state as DeviceLoaded;
      
      final newQuery = event.searchQuery ?? s.searchQuery;
      final newFilter = event.filter ?? s.currentFilter;
      
      final filtered = _getFilteredDevices(s.devices, newQuery, newFilter);
      
      emit(DeviceLoaded(
        s.devices,
        alertDevices: const [], // Don't trigger alerts on filter
        filteredDevices: filtered,
        searchQuery: newQuery,
        currentFilter: newFilter,
      ));
    }
  }
}
