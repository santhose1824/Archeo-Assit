import 'package:archeoassist/Color.dart';
import 'package:flutter/material.dart';

class AuthFeilds extends StatefulWidget {
  final controller, hint, icon;
  bool obsecureText;
  AuthFeilds({this.controller, this.hint, this.icon, required this.obsecureText});

  @override
  State<AuthFeilds> createState() => _AuthFeildsState();
}

class _AuthFeildsState extends State<AuthFeilds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: ColorManager.AppTextColor,
          boxShadow: [
            BoxShadow(
              color: ColorManager.AppTextColor.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obsecureText,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: widget.icon,
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
