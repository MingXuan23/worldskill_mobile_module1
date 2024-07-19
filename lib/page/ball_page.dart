import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class BallScreen extends StatefulWidget {
  BallScreen({super.key});

  @override
  _BallScreenState createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen> {
  double _ballX = 0;
  double _ballY = 0;
   StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

void _startListening() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        // Adjust ball position based on gyroscope data
        // We're inverting the x and y here because of how gyroscope axes are oriented
        _ballX += event.y * 0.3 ;
        _ballY += event.x * 0.3;
        
        // Constrain the ball within the container
        _ballX = _ballX.clamp(-1.0, 1.0);
        _ballY = _ballY.clamp(-1.0, 1.0);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: CustomPaint(
            painter: BallPainter(_ballX, _ballY),
          ),
        ),
      ),
    );
  }
}

class BallPainter extends CustomPainter {
  final double x;
  final double y;

  BallPainter(this.x, this.y);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;
    final radius = 20.0;
    final centerX = size.width / 2 + x * (size.width / 2 - radius);
    final centerY = size.height / 2 + y * (size.height / 2 - radius);
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
