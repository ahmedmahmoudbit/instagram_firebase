import 'package:meta/meta.dart';

@immutable
abstract class MainState {}

class Empty extends MainState {}

class Error extends MainState {
  final String error;
  Error(this.error);
}





