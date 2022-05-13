import 'dart:io';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/core/models/posts.dart';
import 'package:instagram_firebase/core/models/stories.dart';
import 'package:instagram_firebase/core/widget/loading.dart';
import 'package:instagram_firebase/features/add_post/cubit/add_post_cubit.dart';
import 'package:instagram_firebase/features/add_post/page/add_post.dart';
import 'package:instagram_firebase/features/comment/page/comments.dart';
import 'package:instagram_firebase/features/home/cubit/home_bloc_cubit.dart';
import 'package:instagram_firebase/features/login/page/login.dart';
import 'package:instagram_firebase/features/stories/page/stories.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  late BuildContext context;
  late HomeBlocCubit cubit;
  HomeBlocState? _state;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    cubit = context.read<HomeBlocCubit>();
    // get posts
    cubit.getPosts();
    var size = MediaQuery.of(context).size;
    return BlocListener<HomeBlocCubit, HomeBlocState>(
      listener: (context, state) {
        _state = state;
        if (state is GetStoriesDetailsSuccessState) {
          onShowStoryTapped(state.storiesModel);
        } else if (state is AddStorySuccessState) {
          showSnackBar("Story added",context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: screenAppBar(),
        body: screenBody(size),
      ),
    );
  }

  AppBar screenAppBar() => AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Instagram",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                onAddBoxTapped(context);
              },
              icon: const Icon(Icons.add_box_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_outlined)),
        ],
      );

  Widget screenBody(Size size) => ListView(
        children: [
          buildStories(),
          const Divider(
            color: Colors.white,
            height: 0.1,
            thickness: 0.4,
          ),
          postsListView(size),
        ],
      );

  Widget postsListView(Size size) {
    return BlocBuilder<HomeBlocCubit, HomeBlocState>(
      buildWhen: (previous, current) => current is HomeSuccessPostStates,
      builder: (context, state) {
        return ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) =>
                buildPostItem(size, cubit.posts[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: cubit.posts.length);
      },
    );
  }

  buildStories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          SizedBox(
            height: 110,
            child: InkWell(
              onTap: () => onAddStoryTapped(),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: const [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg"),
                        radius: 35,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 13,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.add),
                        radius: 11,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Your story",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              child: BlocBuilder<HomeBlocCubit, HomeBlocState>(
                buildWhen: (previous, current) =>
                current is GetHomeStoriesSuccessState,
                builder: (context, state) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    itemBuilder: (context, index) => buildStoryItem(index),
                    itemCount: cubit.homeStories.length,
                    scrollDirection: Axis.horizontal,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  buildStoryItem(int index) {
    StoriesModel story = cubit.homeStories[index];
    return InkWell(
      onTap: () => cubit.getStoriesDetails(story.userId!),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Color(0xff833ab4),
                        Color(0xfffd1d1d),
                        Color(0xfffcb045),
                      ])),
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    story.userImageUrl!),
                radius: 33,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
           Text(
            story.username!,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  buildPostItem(Size size, Post post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () => onAddStoryTapped(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              Color(0xff833ab4),
                              Color(0xfffd1d1d),
                              Color(0xfffcb045),
                            ])),
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.userImageUrl),
                      radius: 23,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      post.locationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        Image(
            height: size.height * 0.4,
            width: double.infinity,
            fit: BoxFit.cover,
            image: NetworkImage(post.postImageUrl)),
        BlocBuilder<HomeBlocCubit, HomeBlocState>(
          buildWhen: (previous, current) =>
              current is LikePostSuccessState ||
              current is UnLikePostSuccessState,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (post.isLiked) {
                          post.likeCount--;
                          post.isLiked = false;
                          cubit.unLikePost(post.postId);
                        } else {
                          post.likeCount++;
                          post.isLiked = true;
                          cubit.likePost(post.postId);
                        }
                      },
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommentsPage(postId: post.postId),
                            ));
                      },
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      )),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                      )),
                ],
              ),
            );
          },
        ),
        BlocBuilder<HomeBlocCubit, HomeBlocState>(
          buildWhen: (previous, current) =>
              current is LikePostSuccessState ||
              current is UnLikePostSuccessState,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.0),
              child: Text(
                "${post.likeCount} Likes",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        const SizedBox(
          height: 4,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: post.postContent)
            ]))),
      ],
    );
  }

  onAddStoryTapped() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    List<File> paths = images!.map((xFile) => File(xFile.path)).toList();
    cubit.addStories(paths);
  }

  onShowStoryTapped(List<StoriesModel> storiesDetails) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StoryPage(storiesDetails: storiesDetails),
    ));
  }

  void onAddBoxTapped(context) {
    showMenu<String>(
      color: const Color(0xE6000000),
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 99.8, 100),
      //position where you want to show the menu on screen
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      items: [
        PopupMenuItem<String>(
          value: '1',
          child: Row(
            children: [
              Text(
                'Post',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const Spacer(),
              const SizedBox(
                width: 8,
              ),
              Icon(MaterialIcons.post_add, color: Theme.of(context).focusColor),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2',
          child: Expanded(
            child: Row(
              children: [
                Text(
                  'Story',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Spacer(),
                Icon(MaterialCommunityIcons.plus_circle_outline,
                    color: Theme.of(context).focusColor),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: '3',
          child: Expanded(
            child: Row(
              children: [
                Text(
                  'Reel',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Spacer(),
                Icon(MaterialIcons.live_tv,
                    color: Theme.of(context).focusColor),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: '4',
          child: Expanded(
            child: Row(
              children: [
                Text(
                  'Live',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Spacer(),
                Icon(Fontisto.livestream, color: Theme.of(context).focusColor),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: '5',
          child: Expanded(
            child: Row(
              children: [
                Text(
                  'logout',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const Spacer(),
                Icon(Fontisto.direction_sign,
                    color: Theme.of(context).focusColor),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        pickImage();
      } else if (itemSelected == "2") {
        //code here
      } else if (itemSelected == "5") {
        signOut(context);
        navigateAndFinish(context, const LoginPage());
      }
    });
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      File file = File(value!.path);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPostPage(
              imageFile: file,
            ),
          ));
    });
  }
}
