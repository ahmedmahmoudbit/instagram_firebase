part of 'chat_bloc_cubit.dart';

@immutable
abstract class ChatBlocState {}

class ChatBlocInitial extends ChatBlocState {}

class GetUsersSuccessState extends ChatBlocInitial {}

class SendMessageSuccessState extends ChatBlocInitial {}

class GetMessagesSuccessState extends ChatBlocInitial {}

class Error extends ChatBlocInitial {
  final String error;
  Error(this.error);
}

