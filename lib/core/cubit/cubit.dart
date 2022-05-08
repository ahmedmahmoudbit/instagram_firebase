import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/core/cubit/state.dart';
import 'package:instagram_firebase/core/network/repository.dart';

class MainBloc extends Cubit<MainState> {
  final Repository _repository;

  MainBloc({
    required Repository repository,
  })
      : _repository = repository,
        super(Empty());

  static MainBloc get(context) => BlocProvider.of(context);

}
