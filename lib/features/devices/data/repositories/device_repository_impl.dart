import 'package:dartz/dartz.dart';
import 'package:noc_task_plexus/features/devices/data/data_sources/device_local_data_source.dart';
import 'package:noc_task_plexus/features/devices/data/data_sources/device_remote_data_source.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;
  final DeviceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Stream<Either<Failure, List<DeviceEntity>>> watchDevices() async* {
    // If online, yield remote data stream and cache it
    // If offline, yield cached data immediately
    if (await networkInfo.isConnected) {
      yield* remoteDataSource.watchDevices().map((devices) {
        // Cache in background
        localDataSource.cacheDevices(devices);
        return Right<Failure, List<DeviceEntity>>(devices);
      });
    } else {
      final cached = await localDataSource.getCachedDevices();
      if (cached.isEmpty) {
        yield Left(CacheFailure('No cached data found'));
      } else {
        yield Right<Failure, List<DeviceEntity>>(cached);
      }
    }
  }

  @override
  Future<Either<Failure, List<DeviceEntity>>> getDevices() async {
    // Simple implementation for initial load if needed
    try {
      final cached = await localDataSource.getCachedDevices();
      return Right(cached);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceEntity>> getDeviceDetails(String id) async {
    // In a real app, this would fetch single device details.
    // Here we just filter the cached list.
    try {
      final devices = await localDataSource.getCachedDevices();
      final device = devices.firstWhere((d) => d.id == id);
      return Right(device);
    } catch (e) {
      return Left(CacheFailure('Device not found'));
    }
  }
}
