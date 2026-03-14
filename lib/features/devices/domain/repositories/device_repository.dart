import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device_entity.dart';

abstract class DeviceRepository {
  Future<Either<Failure, List<DeviceEntity>>> getDevices();
  Stream<Either<Failure, List<DeviceEntity>>> watchDevices();
  Future<Either<Failure, DeviceEntity>> getDeviceDetails(String id);
}
