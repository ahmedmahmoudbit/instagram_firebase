import 'dart:io';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
import 'package:instagram_firebase/core/widget/loading.dart';
import 'package:instagram_firebase/features/comment/cubit/comment_cubit.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  const CommentsPage({Key? key,required this.postId}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late CommentCubit commentsCubit;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentsCubit = context.read<CommentCubit>();
    // remove old comment before open any comment post
    commentsCubit.comments.clear();
    // get Comments after open any post Comment.
    commentsCubit.getComments(postId: widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentCubit, CommentState>(
    listener: (context, state) {
      if (state is CommentAddSuccessState) {
        commentsCubit.getComments(postId: widget.postId);
      }
  },
  child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Comments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildListView(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                 CircleAvatar(
                  backgroundImage: NetworkImage(
                      CacheHelper.getData(key: 'image')),
                  radius: 22,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextFormField(
                      // controller
                      controller: controller,
                      onFieldSubmitted: (value){
                        commentsCubit.addComment(postId: widget.postId, commentContent: value);
                        // remove text after send
                        controller.clear();
                      },
                      textInputAction: TextInputAction.send,
                      style: const TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        hintText: "Add a comment",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ), ace()
        ],
      ),
    ),
);
  }

  ace() {
    if (Platform.isIOS) {
      return const SizedBox(
        height: 19,
      );
    }
    else{
      return const SizedBox(height: 0,);
    }
  }

  void hideLoaderDialog(BuildContext context) {
    Navigator.pop(context);
  }

  Widget buildListView() {
     return BlocBuilder<CommentCubit, CommentState>(
      // build only condition is true (states)
      buildWhen: (previous, current) =>
      current is CommentGetSuccessState || current is CommentAddSuccessState,
      builder: (context, state) {
    return BuildCondition(
      condition: commentsCubit.comments.isNotEmpty,
      builder:(context) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: commentsCubit.comments.length,
        itemBuilder: (context, index) {
          var data = commentsCubit.comments[index];
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      data.userImageUrl!),
                  radius: 18,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: data.username!.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:'   ${data.comment}'
                                  )
                            ])),
                        space5Vertical,
                        Text(
                          data.commentTime!.split(' ')[0],
                          style:
                          const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            ),
          );
        },
      ),
      fallback: (_) => const LoadingPage(),
    );
  },
);
  }
}