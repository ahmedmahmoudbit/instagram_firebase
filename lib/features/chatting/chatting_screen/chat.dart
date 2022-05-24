import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/core/models/messageModel.dart';
import 'package:instagram_firebase/core/models/user_data.dart';
import 'package:instagram_firebase/features/chatting/cubit/chat_bloc_cubit.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({Key? key,required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {

  late ChatBloc cubit;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ChatBloc>(context);
    cubit.messages.clear();
    cubit.getMessages(widget.user.uId!);
    cubit.listenToMessages(widget.user.uId!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatBlocState>(
      listener: (context, state) {},
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
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
                    backgroundImage: NetworkImage(widget.user.imageUrl!),
                    radius: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.user.name!,
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
        body: Column(
          children: [
            buildChattingListView(),
            buildMessageTextFromFiled(),
          ],
        ),
      ),
    );
  }

  Widget buildChattingListView() {
    return Expanded(
      child: BlocBuilder<ChatBloc, ChatBlocState>(
        buildWhen: (previous, current) => current is GetMessagesSuccessState,
        builder: (context, state) {
          return ListView.builder(
            itemCount: cubit.messages.length,
            itemBuilder: (context, index) {
              MessageModel message = cubit.messages[index];

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return buildSenderMessage(message.message!);
              } else {
                return buildReceiverMessage(message.message!);
              }

            },
          );
        },
      ),
    );
  }

  Widget buildSenderMessage(String message) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 15,
          left: 25,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        // width: double.infinity,
        // alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildReceiverMessage(String message) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 25,
          left: 15,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        // width: double.infinity,
        // alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildMessageTextFromFiled() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: messageController,
              style: const TextStyle(color: Colors.black, fontSize: 17),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Write your message",
                hintStyle: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
          ),
          IconButton(
              onPressed: () => sendMessage(),
              icon: Icon(
                Icons.send,
                color: Colors.blue[200],
                size: 22,
              ))
        ],
      ),
    );
  }

  void sendMessage() {
    String messageContent = messageController.text;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String time = DateTime.now().toString();

    if (messageController.text.isNotEmpty) {
      MessageModel message = MessageModel(
        messageId: time + userId,
        senderId: userId,
        reciverId: widget.user.uId!,
        message: messageContent,
        time: time,
      );
      cubit.sendMessage(message);
      messageController.clear();
    }

  }
}
