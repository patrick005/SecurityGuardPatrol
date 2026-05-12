// lib/widgets/guide_popup.dart
import 'package:flutter/material.dart';
import '../models/checkpoint.dart';

Future<void> showGuidePopup(BuildContext context, Checkpoint checkpoint) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text('(${checkpoint.id}) ${checkpoint.name}'),
        content: SingleChildScrollView(
          child: Text(
            checkpoint.description.isEmpty ? '설명 없음' : checkpoint.description,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      );
    },
  );
}