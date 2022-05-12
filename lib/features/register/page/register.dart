import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_firebase/core/constants.dart';
import 'package:instagram_firebase/features/home/page/homePage.dart';
import 'package:instagram_firebase/features/login/page/login.dart';
import 'package:instagram_firebase/features/register/cubit/register_bloc_cubit.dart';
import 'package:instagram_firebase/features/register/widgets/button_login.dart';
import 'package:instagram_firebase/features/register/widgets/text_form_field.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late RegisterBloc cubit;
  bool isDisabled = true;
  XFile? image;

  @override
  void initState() {
    super.initState();
    cubit = context.read<RegisterBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterBlocState>(
      listener: (context, state) {
        if (state is CreateUserSuccessState) {
          navigateAndFinish(context, HomePage());
        } else if (state is Error) {
          showSnackBar(state.error,context);
        } else if (state is RegisterLoadingState) {
          showSnackBar('Please wit ...',context);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                buildProfileImage(),
                space10Vertical,
                TextFormDesign(
                  controller: usernameController, hint: 'username',
                  onChange: (String? text){
                    enableLoginButton();
                  },),
                space10Vertical,
                TextFormDesign(controller: emailController,
                  hint: 'email',
                  type: TextInputType.emailAddress,
                  onChange: (String? text){
                    enableLoginButton();
                  },),
                space10Vertical,
                TextFormDesign(controller: phoneController,
                  hint: 'phone number',
                  type: TextInputType.number,
                  onChange: (String? text){
                    enableLoginButton();
                  },),
                space10Vertical,
                TextFormDesign(
                    controller: passwordController,
                    hint: 'password',
                  onChange: (String? text){
                    enableLoginButton();
                  },),
                space10Vertical,
                TextFormDesign(controller: confirmPasswordController,
                  hint: 'confirm Password',
                  onChange: (String? text){
                    enableLoginButton();
                  },
                  action: TextInputAction.done,),
                space10Vertical,
                if (!isDisabled)
                  BtnLogin(
                    onTap: () {
                      if (image == null) {
                        showSnackBar("Select image!",context);
                        return;
                      }
                      cubit.userRegister(email: emailController.text,
                          password: passwordController.text,
                          name: usernameController.text,
                          phone: phoneController.text,
                          imageFile: File(image!.path));
                    },
                    text: "Sign in",
                  ),
                space10Vertical,
                if (isDisabled)
                  Container(
                      color: Colors.red[400],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Please fill your data.',
                          style: TextStyle(color: Colors.red[100]),),
                      )),
                TextButton(onPressed: () {
                  navigateAndFinish(context, LoginPage());
                }, child: const Text('Login ?'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildProfileImage() {
    return InkWell(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        image = await _picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      child: image == null
          ? Lottie.asset('assets/images/register.json',
          width: 200, height: 200)
          : Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(80),
          child: Image.file(
            File(image!.path),
            fit: BoxFit.fill,
            width: 200,
            height: 200,
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

}
