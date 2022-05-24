import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/core/models/messageModel.dart';
import 'package:instagram_firebase/core/models/user_data.dart';
import 'package:meta/meta.dart';

part 'chat_bloc_state.dart';

class ChatBloc extends Cubit<ChatBlocState> {
  ChatBloc() : super(ChatBlocInitial());

  /// get All user - used application  ------------- start
  List<UserModel> users = [];

  void getUsers() {
    FirebaseFirestore.instance
        .collection("users_instagram")
        .get()
        .then((value) => handleUsersData(value))
        .catchError((error) => emit(Error(error.toString())));
  }

  handleGetUserError(String errorMessage) {
    emit(Error(errorMessage));
  }

  handleUsersData(QuerySnapshot<Map<String, dynamic>> value) {
    users.clear();
    for (var element in value.docs) {
      var user = UserModel.fromMap(element.data());
      // if user is this user ? ignore
      if (user.uId == FirebaseAuth.instance.currentUser!.uid) {
        continue;
      }
      users.add(user);
    }
    emit(GetUsersSuccessState());
  }

  // get All user - used application  ------------- end

  /// send and receive message (chatting)  ------------- start

  List<MessageModel> messages = [];

  void sendMessage(MessageModel message) async {

    // go collection users_instagram +
    await FirebaseFirestore.instance
        .collection("users_instagram")
    // sendId to user (unique every user)
        .doc(message.senderId)
    // collection chats
        .collection("chats")
    // receiveId to user (unique every user)
        .doc(message.reciverId)
    // message collection
        .collection("messages")
    // messageId .
        .doc(message.messageId)
    // set data .
        .set(message.toJson());

    await FirebaseFirestore.instance
        .collection("users_instagram")
        .doc(message.reciverId)
        .collection("chats")
        .doc(message.senderId)
        .collection("messages")
        .doc(message.messageId)
        .set(message.toJson());

    emit(SendMessageSuccessState());
  }

  void getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection("users_instagram")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .get()
        .then((value) {
      messages.clear();

      for (var element in value.docs) {
        MessageModel message = MessageModel.fromJson(element.data());
        messages.add(message);
      }
      emit(GetMessagesSuccessState());
    });
  }

  void listenToMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection("users_instagram")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
    // sort data
        .orderBy("time")
    // get last message  || if you can get first message use (limit)
        .limitToLast(1)
    // stream snapshots
        .snapshots()
    // listen to message .
        .listen((event) {
      // messages.clear();

      print('Docs => ${event.docs.length}');

      // another method
      // MessageModel message = MessageModel.fromJson(event.docs[0].data());
      for (var element in event.docs) {
        MessageModel model = MessageModel.fromJson(element.data());
        messages.add(model);
      }

      emit(GetMessagesSuccessState());
    });
  }

// send and receive message (chatting)  ------------- end

}
