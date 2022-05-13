import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_firebase/core/models/posts.dart';
import 'package:instagram_firebase/core/models/stories.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
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
        // go to collection posts_instagram
        .collection('posts_instagram')
        // sort data by postId
        .orderBy('postId'.split(':')[0],descending: true)
        // .where('age',isGreaterThan: 18)
        // get all data
        .get()
        // after get all data
        .then((QuerySnapshot querySnapshot) async {

      // empty data after every get post
      posts = [];

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
        // count of post
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

  /// --------------------------------------- Stories
  void addStories(List<File> files) async {
    int counter =1;
    for (var file in files) {
      // 0
      print('Add story $counter');
      await addStory(file);
      print('Story $counter added');
      counter++;
    }
  }

  Future<bool> addStory(File file) async {
    String ref =
        'stories_instagram/${FirebaseAuth.instance.currentUser!.uid + DateTime.now().toString()}';

    // 1 upload image
    await _uploadImage(file, ref);
    // 2 get image url
    String storyImageUrl = await _getImageUrl(ref);
    print('storyImageUrl => $storyImageUrl');
    // 3 add on firestore
    await _insertStoryData(storyImageUrl);

    return true;
  }

  Future<bool> _uploadImage(File imageFile, String ref) async {
    try {
      await FirebaseStorage.instance.ref(ref).putFile(imageFile);

      return true;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      emit(Error(e.toString()));
    }
    return false;
  }

  Future<String> _getImageUrl(String ref) async {
    String imageUrl = await FirebaseStorage.instance.ref(ref).getDownloadURL();

    return imageUrl;
  }

  Future<bool> _insertStoryData(String storyImageUrl) async {
    StoriesModel story = StoriesModel(
      username: CacheHelper.getData(key: "username"),
      userId: FirebaseAuth.instance.currentUser!.uid,
      userImageUrl: CacheHelper.getData(key: "image"),
      storyImageUrl: storyImageUrl,
      storyTime: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    FirebaseFirestore.instance
        .collection("stories_instagram")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(story.toMap());

    FirebaseFirestore.instance
        .collection("stories_instagram")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("myStories")
        .doc(story.storyTime)
        .set(story.toMap())
        .then((value) {


      emit(AddStorySuccessState());
      getHomeStories();
      return true;
    }).catchError((error) {
      emit(Error(error.toString()));
    });

    return false;
  }

  List<StoriesModel> storiesDetails = [];

  List<StoriesModel> homeStories = [];

  void getHomeStories() {
    FirebaseFirestore.instance.collection("stories_instagram").get().then((value) {
      homeStories.clear();
      for (var element in value.docs) {
        StoriesModel story = StoriesModel.fromMap(element.data());

        const int day = 86400000;
        int currentMillis = DateTime.now().millisecondsSinceEpoch;
        int storyMillis = int.tryParse(story.storyTime!) ?? 0;
        int betweenMillis = currentMillis - storyMillis;
        bool isLessThanDay = betweenMillis < day;

        print('currentMillis $currentMillis');
        print('storyMillis $storyMillis');
        print('day $day');
        print('betweenMillis $betweenMillis');
        print('isLessThanDay $isLessThanDay');

        if (isLessThanDay) {
          homeStories.add(story);
        }
      }
      emit(GetHomeStoriesSuccessState());
    });
  }

  void getStoriesDetails(String userId) {
    FirebaseFirestore.instance
        .collection("stories_instagram")
        .doc(userId)
        .collection("myStories")
        .get()
        .then((value) {
      print('story docs => ${value.docs.length}');

      storiesDetails.clear();

      for (var element in value.docs) {
        StoriesModel story = StoriesModel.fromMap(element.data());

        const int day = 86400000;
        int currentMillis = DateTime.now().millisecondsSinceEpoch;
        int storyMillis = int.tryParse(story.storyTime!) ?? 0;
        int betweenMillis = currentMillis - storyMillis;
        bool isLessThanDay = betweenMillis < day;

        print('currentMillis $currentMillis');
        print('storyMillis $storyMillis');
        print('day $day');
        print('betweenMillis $betweenMillis');
        print('isLessThanDay $isLessThanDay');

        if (isLessThanDay) {
          storiesDetails.add(story);
        }
        else{
          FirebaseFirestore.instance.collection("stories").doc(userId)
              .collection("myStories").doc(story.storyTime).delete();
        }
      }
      print(storiesDetails.length);
      emit(GetStoriesDetailsSuccessState(storiesDetails));
    });
  }

}
