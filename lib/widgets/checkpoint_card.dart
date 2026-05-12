// lib/widgets/checkpoint_card.dart

import 'package:flutter/material.dart';
import '../models/checkpoint.dart';

class CheckpointCard extends StatelessWidget {
  final String title;
  final Checkpoint? checkpoint;
  final bool isCurrent;
  final VoidCallback? onLongPress;

  // 사용자 메모
  final String? memo;

  const CheckpointCard({
    super.key,
    required this.title,
    required this.checkpoint,
    this.isCurrent = false,
    this.onLongPress,
    this.memo,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isCurrent ? Colors.red : Colors.grey;
    final bgColor = isCurrent ? Colors.white : Colors.grey.shade200;
    //개인메모가 있다면 우선처리, 메모와 기본주석이 없다면 없다는 표시
    final displayText =
        memo != null && memo!.trim().isNotEmpty
            ? memo!
            : (checkpoint?.description.isEmpty ?? true)
                ? '설명 없음'
                : checkpoint!.description;

    return Expanded(
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: isCurrent ? 2 : 1,
            ),
          ),
          child: checkpoint == null
              ? Text(
                  '$title\n없음',
                  style: const TextStyle(fontSize: 16),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      '(${checkpoint!.id}) ${checkpoint!.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Expanded(
                      child: Text(
                        displayText,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}