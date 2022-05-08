import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        .then((QuerySnapshot querySnapshot) {

      // empty data after every get post
      posts.clear();
      // loop for all user and get all data (user user)
      for (var doc in querySnapshot.docs) {
        // get data
        Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
        // set data to Post model
        Post post = Post.fromJson(json);
        // add data .
        posts.add(post);
      }
      emit(HomeSuccessPostStates());
    });
  }

}
