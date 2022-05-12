import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_firebase/core/models/posts.dart';
import 'package:meta/meta.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit() : super(AddPostInitial());

  late Post _post;

  void addPost({required String postContent, required File imageFile}) {
    _post = Post(postContent: postContent,type: 0);
    _uploadImage(imageFile);
  }

  void _uploadImage(File imageFile) async {
    try {
      emit(AddPostLoadingState());
      await FirebaseStorage.instance
          .ref('profile_instagram/${_post.postId}')
          .putFile(imageFile);

      _getImageUrl();
    } on FirebaseException catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _getImageUrl() async {
    _post.postImageUrl = await FirebaseStorage.instance
        .ref('profile_instagram/${_post.postId}')
        .getDownloadURL();

    _insertNewPost();
  }

  void _insertNewPost() {
    FirebaseFirestore.instance
        .collection("posts_instagram")
        .doc(_post.postId)
        .set(_post.toJson())
        .then((value) {
      emit(AddPostSuccessState());
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

}
