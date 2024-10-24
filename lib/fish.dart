import 'dart:math';
import 'package:flutter/material.dart';

class Fish {
  Color color;
  double speed;

  Fish(this.color, this.speed);
}

class FishWidget extends StatefulWidget {
  final Fish fish;

  FishWidget({required this.fish});

  @override
  _FishWidgetState createState() => _FishWidgetState();
}

class _FishWidgetState extends State<FishWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double xPos, yPos;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.fish.speed.toInt()), 
      vsync: this
    );
    _controller.repeat(reverse: true); // Fish moving back and forth

    // Initial position fish
    xPos = Random().nextDouble() * 250;
    yPos = Random().nextDouble() * 250;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Adjust fish position 
        xPos += Random().nextDouble() * 2;
        yPos += Random().nextDouble() * 2;
        
        // Keep fish within container
        if (xPos > 250) xPos = 0;
        if (yPos > 250) yPos = 0;

        return Positioned(
          left: xPos,
          top: yPos,
          child: Image.asset(
            'assets/fish.png',  
            width: 50,          
            height: 50,         
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();  
    super.dispose();
  }
}
