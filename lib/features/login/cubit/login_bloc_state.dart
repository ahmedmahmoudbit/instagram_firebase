part of 'login_bloc_cubit.dart';

@immutable
abstract class LoginBlocState {}

class LoginBlocInitial extends LoginBlocState {}

class Error extends LoginBlocState {
  final String error;
  Error(this.error);
}


class LoginSuccessState extends LoginBlocState {}

class LoginLoadingState extends LoginBlocState {}

class HomeGetUserLoadingState extends LoginBlocState {}

class HomeGetUserSuccessState extends LoginBlocState {}
