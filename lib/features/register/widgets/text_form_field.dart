import 'package:flutter/material.dart';

class TextFormDesign extends StatelessWidget {

   TextFormDesign(
      {Key? key,
      required this.hint,
      required this.controller,
      this.onChange,
      this.type = TextInputType.text,
      this.action = TextInputAction.next,
      })
      : super(key: key);

  final String hint;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type,
      controller: controller,
      onChanged: onChange,
      textInputAction: action,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hint,
        fillColor: Colors.grey[400],
        filled: true,

      ),
    );
  }
}
