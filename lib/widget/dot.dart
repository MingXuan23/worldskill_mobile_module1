import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final double size;
  final Color color;

  Dot({this.size = 10.0, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}