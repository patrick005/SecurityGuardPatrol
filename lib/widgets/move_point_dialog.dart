// lib/widgets/move_point_dialog.dart

import 'package:flutter/material.dart';
import '../models/checkpoint.dart';

Future<int?> showMovePointDialog(
  BuildContext context,
  List<Checkpoint> points, {
  required Map<int, String> memoMap,
}) {
  return showDialog<int>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('포인트 강제이동'),
        content: SizedBox(
          width: 350,
          height: 400,
          child: ListView.builder(
            itemCount: points.length,
            itemBuilder: (context, index) {
              final point = points[index];

              final memo = memoMap[point.id] ?? '';
              final displayText = memo.trim().isNotEmpty
                  ? memo
                  : point.description;

              return ListTile(
                title: Text('(${point.id}) ${point.name}'),
                subtitle: Text(
                  displayText.isEmpty ? '설명 없음' : displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.pop(context, index),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      );
    },
  );
}