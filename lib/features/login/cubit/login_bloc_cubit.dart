import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/core/models/user_data.dart';
import 'package:meta/meta.dart';

part 'login_bloc_state.dart';

class LoginBloc extends Cubit<LoginBlocState> {
  LoginBloc() : super(LoginBlocInitial());

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      getUserDate();
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  UserModel? userModel;
  void getUserDate() {
    emit(HomeGetUserLoadingState());

    FirebaseFirestore.instance.collection('users_instagram').doc(uIdUser).get().then((value) {
      userModel = UserModel.fromMap(value.data()!);
      print(FirebaseAuth.instance.currentUser!.emailVerified);
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(Error(error));
    });
  }

}
