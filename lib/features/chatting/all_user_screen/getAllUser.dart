import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/core/models/user_data.dart';
import 'package:instagram_firebase/core/widget/loading.dart';
import 'package:instagram_firebase/features/chatting/chatting_screen/chat.dart';
import 'package:instagram_firebase/features/chatting/cubit/chat_bloc_cubit.dart';

class AllUserChattingPage extends StatefulWidget {
  const AllUserChattingPage({Key? key}) : super(key: key);

  @override
  State<AllUserChattingPage> createState() => _AllUserChattingPageState();
}

class _AllUserChattingPageState extends State<AllUserChattingPage> {
  late ChatBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<ChatBloc>();
    bloc.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatBlocState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Chats"),
          ),
          body:
          RefreshIndicator(
            onRefresh: () async {
              bloc.getUsers();
            },
            child: BuildCondition(
              condition: bloc.users.isNotEmpty,
              builder:(context) => ListView.builder(
                itemCount: bloc.users.length,
                itemBuilder: (context, index) => buildChatItem(index),
              ),
              fallback:(context) => const LoadingPage() ,
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem(int index) {
    UserModel user = bloc.users[index];

    return InkWell(
      onTap: () =>
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChattingPage(user: user),
              )),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Row(
          children: [
            Stack(
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
                  backgroundImage: NetworkImage(user.imageUrl!),
                  radius: 23,
                ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                user.name!,
                // "Amir Mohammed",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


