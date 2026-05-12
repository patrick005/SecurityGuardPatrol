// lib/widgets/control_buttons.dart
import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback onCheck;
  final VoidCallback onPass;
  final VoidCallback onMove;

  const ControlButtons({
    super.key,
    required this.onCheck,
    required this.onPass,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPass,
            child: const Text('패스'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: onCheck,
            child: const Text('체크'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: onMove,
            child: const Text('포인트 강제이동'),
          ),
        ),
      ],
    );
  }
}