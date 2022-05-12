import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/core/models/user_data.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
import 'package:meta/meta.dart';

part 'register_bloc_state.dart';

class RegisterBloc extends Cubit<RegisterBlocState> {
  RegisterBloc() : super(RegisterBlocInitial());

  String? name;
  String? email;
  String? phone;
  File? imageFile;
  String? imageUrl;
  String? uId;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
    required File imageFile,
  }) async {
    this.email = email;
    this.name = name;
    this.phone = phone;
    this.imageFile = imageFile;

    emit(RegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
      uId = value.user!.uid;
      _uploadImage();
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  void _uploadImage() async {
    print('_uploadImage -----------------');
    try {
      await FirebaseStorage.instance
          .ref('profile_instagram/$uId')
          .putFile(imageFile!);

      _getImageUrl();
    } on FirebaseException catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _getImageUrl() async {
    print('_getImageUrl -----------------');
    imageUrl = await FirebaseStorage.instance
        .ref('profile_instagram/$uId')
        .getDownloadURL();
    userCreate();
  }

  void userCreate() async {
    UserModel userModel = UserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      imageUrl: imageUrl,
    );
    print('userCreate -----------------');
    await FirebaseFirestore.instance
        .collection('users_instagram')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      saveData(userModel);
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  void saveData(UserModel userModel) {
    CacheHelper.saveData(
        key: 'username', value: userModel.name);
    CacheHelper.saveData(
        key: 'image', value: userModel.imageUrl);
    CacheHelper.saveData(
        key: 'uId', value: userModel.uId);
  }

}
