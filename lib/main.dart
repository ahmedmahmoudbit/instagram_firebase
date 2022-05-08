import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/core/cubit/MyBlocObserver.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
import 'package:instagram_firebase/core/network/remote/dio_helper.dart';
import 'package:instagram_firebase/features/add_post/cubit/add_post_cubit.dart';
import 'package:instagram_firebase/features/home/cubit/home_bloc_cubit.dart';
import 'package:instagram_firebase/features/home/page/homePage.dart';
import 'package:instagram_firebase/features/login/cubit/login_bloc_cubit.dart';
import 'package:instagram_firebase/features/login/page/login.dart';
import 'package:instagram_firebase/features/register/cubit/register_bloc_cubit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await CacheHelper.init();

  Widget widget;
  uIdUser = CacheHelper.getData(key: 'uId') ?? '';

  if (uIdUser != null) {
    widget = HomePage();
  } else {
    widget = const LoginPage();
  }

  runApp(MyApp(startWidget: widget,));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider(create: (context) => LoginBloc(),),
       BlocProvider(create: (context) => RegisterBloc(),),
       BlocProvider(create: (context) => AddPostCubit(),),
       BlocProvider(create: (context) => HomeBlocCubit()..getPosts(),),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
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
        home: startWidget,
      ),
    );
  }
}
