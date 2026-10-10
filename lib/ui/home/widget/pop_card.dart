import 'package:flutter/material.dart';

class PopCard extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: Icon(Icons.close),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(20, 0, 20, 20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
