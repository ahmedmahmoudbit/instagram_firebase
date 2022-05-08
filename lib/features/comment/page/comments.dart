import 'dart:io';
import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Comments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 66,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: const NetworkImage(
                            "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg"),
                        radius: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: const TextSpan(children: [
                                    TextSpan(
                                        text: 'AmirMohammed',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                        '  some location area name..some location area name..  some location area name..some location area name..')
                                  ])),
                              Text(
                                "2h",
                                style:
                                TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ))
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: const NetworkImage(
                      "https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg"),
                  radius: 22,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.send,
                      style: const TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        hintText: "Add a comment",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
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
    );
  }
  ace() {
    if (Platform.isIOS) {
      return SizedBox(
        height: 19,
      );
    }
    else{
      return const SizedBox(height: 0,);
    }
  }
}