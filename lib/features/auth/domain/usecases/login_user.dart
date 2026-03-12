import 'package:dartz/dartz.dart';
import 'package:noc_task_plexus/core/error/failures.dart';
import 'package:noc_task_plexus/core/usecases/usecase.dart';
import 'package:noc_task_plexus/features/auth/domain/entities/user.dart';
import 'package:noc_task_plexus/features/auth/domain/repositories/auth_repository.dart';

class LoginUser implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  LoginUser(this.repository);
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
