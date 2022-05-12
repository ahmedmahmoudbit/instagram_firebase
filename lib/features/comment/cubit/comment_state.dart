part of 'comment_cubit.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}

class Error extends CommentState {
  final String error;
  Error(this.error);
}


class CommentAddSuccessState extends CommentState {}

class CommentGetSuccessState extends CommentState {}

class CommentGetLoadingState extends CommentState {}