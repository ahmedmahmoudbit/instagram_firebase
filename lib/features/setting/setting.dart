import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/core/auth.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
import 'package:instagram_firebase/features/login/cubit/login_bloc_cubit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  late LoginBloc cubit;
  final FingerPrint _fingerPrint = FingerPrint();
  late bool isSwitch;

  @override
  void initState() {
    super.initState();
    cubit = context.read<LoginBloc>();
    cubit.getUserDate();
    isSwitch = CacheHelper.getData(key: 'finger') ?? false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Switch(
              value:isSwitch,
              // switch
              inactiveThumbColor: Colors.lightBlue,
              // slider
              inactiveTrackColor: Colors.indigoAccent,
              onChanged: (value) {
                  enableFinger(value);
              },
            ),
          ),
        );
  }
  void enableFinger(bool value) async {
    if (!value) {
      bool isFingerEnabled = await _fingerPrint.isFingerPrintEnable();
      if (isFingerEnabled) {
        CacheHelper.saveData(key: 'email', value: cubit.userModel!.email);
        CacheHelper.saveData(key: 'password', value: '123456');
        print('------------------------------ ${cubit.userModel!.email}');
        print('------------------------------ 123456');
      }
      else {
        CacheHelper.removeData(key: 'email');
        CacheHelper.removeData(key: 'password');
      }
    }
    setState(() {
      isSwitch = value;
      CacheHelper.saveData(key: 'finger', value: value);
      print('------------------------------ $isSwitch');
    });
  }
}
