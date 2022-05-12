import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/core/models/posts.dart';
import 'package:meta/meta.dart';

part 'home_bloc_state.dart';

class HomeBlocCubit extends Cubit<HomeBlocState> {
  HomeBlocCubit() : super(HomeBlocInitial());

  // list empty
  List<Post> posts = [];

  void getPosts()async {
    emit(HomeLoadingPostStates());

    // go to collection posts_instagram and get all date by use QuerySnapshot
    await FirebaseFirestore.instance
        .collection('posts_instagram')
        .get()
        .then((QuerySnapshot querySnapshot) async {

      // empty data after every get post
      posts.clear();
      // loop for all user and get all data (user user)
      for (var doc in querySnapshot.docs) {
        // get data
        Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

        var likes = await FirebaseFirestore.instance
            .collection("posts_instagram")
            .doc(json["postId"])
            .collection("likes")
            .get();

        // set data to Post model
        Post post = Post.fromJson(json);
        post.likeCount = likes.docs.length;

        for (var element in likes.docs) {
          if (element.data()["userId"] ==
              FirebaseAuth.instance.currentUser!.uid) {
            post.isLiked = true;
            break;
          }
          else{
            post.isLiked = false;
          }
        }

        // add data .
        posts.add(post);
      }
      // sort data A - Z
       // posts.reversed;
      emit(HomeSuccessPostStates());
    });
  }

  void likePost(String postId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("posts_instagram")
        .doc(postId)
        .collection("likes")
        .doc(uid)
        .set({"userId": uid});

    emit(LikePostSuccessState());
  }

  void unLikePost(String postId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("posts_instagram")
        .doc(postId)
        .collection("likes")
        .doc(uid)
        .delete();

    emit(UnLikePostSuccessState());
  }

}
