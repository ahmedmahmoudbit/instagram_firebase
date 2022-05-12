import 'dart:io';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/features/add_post/cubit/add_post_cubit.dart';
import 'package:instagram_firebase/features/home/page/homePage.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key, required this.imageFile}) : super(key: key);
  final File imageFile;

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController contentController = TextEditingController();
  late AddPostCubit addPostCubit;

  @override
  void initState() {
    super.initState();
    addPostCubit = context.read<AddPostCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPostCubit, AddPostState>(
      listener: (context, state) {
        if (state is AddPostSuccessState) {
          navigateAndFinish(context, HomePage());
        } else if (state is Error) {
          showSnackBar(state.error,context);
        }
      },
      builder:(context, state)=> Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            "New Post",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            BuildCondition(
              condition: state is AddPostLoadingState,
              builder:(_)=> Container(
                width: 45.0,
                height: 45.0,
                child: const CupertinoActivityIndicator(color: Colors.grey,),
              ),
              fallback: (_)=> InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  showSnackBar('Please wit ...',context);
                  addPostCubit.addPost(postContent: contentController.text, imageFile: widget.imageFile);
                },
                child:
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    "Share",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: 30,
                child: Image.file(
                  widget.imageFile,
                  fit: BoxFit.contain,
                )),
            Expanded(
              child: TextFormField(
                controller: contentController,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                decoration: const InputDecoration(
                    hintText: "Write a caption.",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}