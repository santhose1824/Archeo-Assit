import 'package:archeoassist/Color.dart';
import 'package:flutter/material.dart';

class AuthButtons extends StatefulWidget {
  final onPressed,text;
  AuthButtons({this.onPressed,this.text});

  @override
  State<AuthButtons> createState() => _AuthButtonsState();
}

class _AuthButtonsState extends State<AuthButtons> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: Text(widget.text),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF112A46),
        onPrimary: ColorManager.primaryTextColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // BorderRadius
        ),
        minimumSize: Size(300, 50),
      ),
    );
  }
}
