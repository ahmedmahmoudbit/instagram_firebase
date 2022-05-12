import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/core/models/comments.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
import 'package:meta/meta.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  List<Comment> comments = [];

  // post / postId / comments / commentId / commentData
  void addComment({
    required String postId,
    required String commentContent,
  }) {
    // id user
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var commentTime = DateTime.now().toString().replaceAll(" ", "");

    // object from data to send firebase .
    Comment comment = Comment(
      commentId: commentTime + uid,
      comment: commentContent,
      username: CacheHelper.getData(key: "username"),
      userId: uid,
      userImageUrl: CacheHelper.getData(key: "image"),
      commentTime: DateTime.now().toString(),
    );

    FirebaseFirestore.instance
    // go to posts_instagram collection
        .collection("posts_instagram")
    // go to the id of post
        .doc(postId)
    // go to the comments collection
        .collection("comments")
    // go to the id of comments
        .doc(comment.commentId)
    // add to comment above
        .set(comment.toJson())
        .then((value) {
      emit(CommentAddSuccessState());
    } )
        .catchError((error) => emit(
    Error(error.toString()),
    ));
  }

  void getComments({required String postId}) {
    FirebaseFirestore.instance
        .collection("posts_instagram")
        .doc(postId)
        .collection("comments")
    // get all comments
        .get()
        .then(
          (value) {
            // delete any data before add
        comments.clear();
        // loop about all data
        for (var element in value.docs) {
            var json = element.data();
            var comment = Comment.fromJson(json);
            comments.add(comment);
          }

        emit(CommentGetSuccessState());
      },
    ).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  handleComments(void value) {}

}
