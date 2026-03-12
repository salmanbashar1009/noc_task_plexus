import 'package:dartz/dartz.dart';
import 'package:noc_task_plexus/core/error/failures.dart';
import 'package:noc_task_plexus/core/network/network_info.dart';
import 'package:noc_task_plexus/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:noc_task_plexus/features/auth/domain/entities/user.dart';
import 'package:noc_task_plexus/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await localDataSource.loginUser(email, password);
      if (result != null) {
        await localDataSource.cacheToken(result['token']);
        final user = User(
          email: result['user']['email'],
          name: result['user']['name'],
        );

        return Right(user);
      } else {
        return const Left(ServerFailure('Invalid credentials'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
