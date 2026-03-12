import 'package:dartz/dartz.dart';
import 'package:noc_task_plexus/core/error/failures.dart';
import 'package:noc_task_plexus/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}
