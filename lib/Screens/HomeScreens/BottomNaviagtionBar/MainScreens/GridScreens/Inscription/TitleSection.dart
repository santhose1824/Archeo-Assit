import 'package:archeoassist/Color.dart';
import 'package:flutter/material.dart';
class TitleSection extends StatelessWidget {
  final String title;
  final double height;

  const TitleSection(this.title, this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB((0.32 * height), 0, 0, 0),
            child: Text(
              title,
              style: TextStyle(fontSize: (0.6 * height), fontFamily: 'SFBold', color: ColorManager.GridColor),
            ),
          ),
        ],
      ),
    );
  }
}