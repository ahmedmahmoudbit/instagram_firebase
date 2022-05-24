import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_firebase/core/auth.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';
import 'package:instagram_firebase/features/home/page/homePage.dart';
import 'package:instagram_firebase/features/login/cubit/login_bloc_cubit.dart';
import 'package:instagram_firebase/features/register/page/register.dart';
import 'package:instagram_firebase/features/register/widgets/button_login.dart';
import 'package:instagram_firebase/features/register/widgets/text_form_field.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isDisabled = true;
  LoginBloc cubit = LoginBloc();
  int? _state;

  // finger
  late bool isFinger;
  final FingerPrint _fingerPrint = FingerPrint();

  @override
  void initState() {
    super.initState();
    cubit = context.read<LoginBloc>();
    isFinger = CacheHelper.getData(key: 'finger') ?? false;
    print('------------------------------ $isFinger');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginBlocState>(
      listener: (context, state) {
      if (state is HomeGetUserSuccessState) {
        _state = 1;
        navigateAndFinish(context, HomePage());
      } else if (state is Error) {
        _state = 2;
        showSnackBar(state.error.toString(), context);
      } else if (state is LoginLoadingState) {
        _state = 3;
      }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Lottie.asset('assets/images/login.json', width: 200, height: 200),
                TextFormDesign(
                  controller: emailController,
                  hint: 'email',
                  onChange: (String? text){
                    enableLoginButton();
                  },
                ),
                space10Vertical,
                TextFormDesign(
                    controller: passwordController,
                    hint: 'password',
                    type: TextInputType.text,
                    onChange: (String? text){
                      enableLoginButton();
                    },
                    action: TextInputAction.done),
                space10Vertical,
                if (!isDisabled)
                BtnLogin(
                  onTap: (){
                    showSnackBar('Please wit ...',context);
                    cubit.userLogin(email: emailController.text, password: passwordController.text);
                  } ,
                  text: "Login",
                ),
                space20Vertical,
                if (isDisabled)
                  Container(
                    color: Colors.red[400],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Please enter your email and password',
                          style: TextStyle(color: Colors.red[100]),),
                      )),
                if (!isFinger)
                  InkWell(
                    onTap: (){
                      fingerLogin();
                    },
                    child: Container(
                      height: 130,
                      width: 100,
                      child: Icon(Icons.fingerprint_rounded,color: Colors.white,size: 64),
                    ),
                  ),
                TextButton(
                    onPressed: () {
                      navigateAndFinish(context, const RegisterPage());
                    },
                    child: const Text("you Don't have a account ?"))
              ],
            ),
          ),
        ),
      ),
    );
  }
  void enableLoginButton() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isDisabled = false;
      setState(() {});
    } else {
      isDisabled = true;
      setState(() {});
    }
  }


  void fingerLogin() async {
    bool isFinished = await _fingerPrint.isFingerPrintEnable();
    if (isFinished) {
      bool isAuth = await _fingerPrint.isAuth('login finger print');
      if (isAuth) {
        String mail = CacheHelper.getData(key: 'email');
        String pass = CacheHelper.getData(key: 'password');
        cubit.userLogin(email: mail, password: pass);
      }
    }
  }

}

