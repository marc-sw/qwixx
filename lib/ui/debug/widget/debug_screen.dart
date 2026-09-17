import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DebugScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("Debugging this"),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  duration: const Duration(milliseconds: 1000),
                  begin: Offset(1, 1),
                  end: Offset(1.1, 1.1),
                  curve: Curves.easeInOut,
                ),
      ),
    );
  }
}
