part of 'home_bloc_cubit.dart';

@immutable
abstract class HomeBlocState {}

class HomeBlocInitial extends HomeBlocState {}

class HomeLoadingPostStates extends HomeBlocState {}

class HomeSuccessPostStates extends HomeBlocState {}

class LikePostSuccessState extends HomeBlocState {}

class UnLikePostSuccessState extends HomeBlocState {}

class Error extends HomeBlocState {
  final String error;
  Error(this.error);
}

