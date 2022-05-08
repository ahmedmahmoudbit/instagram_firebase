part of 'register_bloc_cubit.dart';

@immutable
abstract class RegisterBlocState {}

class Error extends RegisterBlocState {
  final String error;
  Error(this.error);
}

class RegisterBlocInitial extends RegisterBlocState {}

class RegisterLoadingState extends RegisterBlocState {}

class CreateUserSuccessState extends RegisterBlocState {}

