import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/core/cubit/MyBlocObserver.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
import 'package:instagram_firebase/core/network/remote/dio_helper.dart';
import 'package:instagram_firebase/features/add_post/cubit/add_post_cubit.dart';
import 'package:instagram_firebase/features/chatting/all_user_screen/getAllUser.dart';
import 'package:instagram_firebase/features/chatting/cubit/chat_bloc_cubit.dart';
import 'package:instagram_firebase/features/comment/cubit/comment_cubit.dart';
import 'package:instagram_firebase/features/home/cubit/home_bloc_cubit.dart';
import 'package:instagram_firebase/features/home/page/homePage.dart';
import 'package:instagram_firebase/features/login/cubit/login_bloc_cubit.dart';
import 'package:instagram_firebase/features/login/page/login.dart';
import 'package:instagram_firebase/features/register/cubit/register_bloc_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await CacheHelper.init();


  Widget widget;
  uIdUser = CacheHelper.getData(key: 'uId');

  if (uIdUser != null) {
    widget = HomePage();
  } else {
    widget = const LoginPage();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    // print token .
    FirebaseMessaging.instance
        .getToken()
        .then((value) => print('token is $value'));

    FirebaseMessaging.onMessage.listen((event) {
      print('test notification is ----- ${event.data}');
      print('test notification is ----- ${event.notification!.title}');
      print('test notification is ----- ${event.notification!.body}');
      showNotification(event.notification!);
    });
  }

  void showNotification(RemoteNotification notification) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    // initialise the plugin.
    // app_icon needs to be a added as a
    // drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');


    /// define platforms .
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    //
    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     MacOSInitializationSettings();


    /// Initialization platforms
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMacOS
    );

    // select notification | payload = data from FirebaseMessaging
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) => selectNotification(payload!),);

    // channels notification .
    channelNotification(flutterLocalNotificationsPlugin,notification);

  }

  void selectNotification(String payload) {
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
      builder: (context) => const AllUserChattingPage(),
    ),);
    // navigateAndFinish(context, const AllUserChattingPage());
  }

  void channelNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin ,
      RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        // Importance
        importance: Importance.max,
        // Priority
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(

      // 1- number of notification => notification.hashCode = Not a specific number
      // 0 = one message only .

      // 2- title of message
      // 3- body of message

        notification.hashCode, notification.title, notification.body, platformChannelSpecifics,
        payload: 'item x');}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => AddPostCubit(),
        ),
        BlocProvider(
          create: (context) => HomeBlocCubit(),
        ),
        BlocProvider(
          create: (context) => CommentCubit(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black12,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black12,
          ),
          focusColor: Colors.white,
          textTheme: const TextTheme(
              bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 16,
          )),
          primarySwatch: Colors.blue,
        ),
        home: widget.startWidget,
      ),
    );
  }


}


