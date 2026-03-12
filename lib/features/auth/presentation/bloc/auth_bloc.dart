import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc_task_plexus/features/auth/domain/usecases/login_user.dart';
import 'package:noc_task_plexus/features/auth/presentation/bloc/auth_event.dart';
import 'package:noc_task_plexus/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final failureOrUser = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    failureOrUser.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
