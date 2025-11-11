import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../data/auth_repository.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthCheckRequested extends AuthEvent {}

final class AuthLogoutRequested extends AuthEvent {}

final class AuthLoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  AuthLoginSubmitted(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

final class AuthRegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;
  AuthRegisterSubmitted(this.name, this.email, this.password);
  @override
  List<Object?> get props => [name, email, password];
}

sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {}

final class AuthUnauthenticated extends AuthState {
  final String? message;
  AuthUnauthenticated({this.message});
  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  AuthBloc(this._repo) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      final ok = await _repo.isAuthenticated();
      emit(ok ? AuthAuthenticated() : AuthUnauthenticated());
    });
    on<AuthLogoutRequested>((event, emit) async {
      await _repo.logout();
      emit(AuthUnauthenticated());
    });
    on<AuthLoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await _repo.login(email: event.email, password: event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        String errorMessage = 'Login failed';
        if (e is DioException) {
          if (e.response != null) {
            final data = e.response!.data;
            if (data is Map && data.containsKey('message')) {
              errorMessage = data['message'].toString();
            } else if (data is Map && data.containsKey('error')) {
              errorMessage = data['error'].toString();
            } else {
              errorMessage = e.response!.statusMessage ?? 'Login failed';
            }
          } else {
            errorMessage = e.message ?? 'Network error';
          }
        }
        emit(AuthUnauthenticated(message: errorMessage));
      }
    });
    on<AuthRegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await _repo.register(
            name: event.name, email: event.email, password: event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        String errorMessage = 'Register failed';
        if (e is DioException) {
          if (e.response != null) {
            final data = e.response!.data;
            if (data is Map) {
              // Check for validation errors
              if (data.containsKey('errors')) {
                final errors = data['errors'] as Map;
                if (errors.containsKey('email')) {
                  errorMessage = 'Email: ${(errors['email'] as List).first}';
                } else if (errors.containsKey('password')) {
                  errorMessage = 'Password: ${(errors['password'] as List).first}';
                } else if (errors.containsKey('name')) {
                  errorMessage = 'Name: ${(errors['name'] as List).first}';
                } else {
                  errorMessage = errors.values.first.toString();
                }
              } else if (data.containsKey('message')) {
                errorMessage = data['message'].toString();
              } else {
                errorMessage = e.response!.statusMessage ?? 'Register failed';
              }
            }
          } else {
            errorMessage = e.message ?? 'Network error';
          }
        }
        emit(AuthUnauthenticated(message: errorMessage));
      }
    });
  }
}
