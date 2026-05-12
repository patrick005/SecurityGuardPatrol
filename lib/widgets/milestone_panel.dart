// lib/widgets/milestone_panel.dart

import 'package:flutter/material.dart';

class MilestonePanel extends StatelessWidget {
  final int totalCount;
  final int currentIndex;
  final Set<int> checkedIndices;
  final Set<int> passedIndices;

  const MilestonePanel({
    super.key,
    required this.totalCount,
    required this.currentIndex,
    required this.checkedIndices,
    required this.passedIndices,
  });

  @override
  Widget build(BuildContext context) {
    final completed = checkedIndices.length;
    final passCount = passedIndices.length;

    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '진행도',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          Text(
            '$completed / $totalCount',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),

          if (passCount > 0) ...[
            const SizedBox(height: 4),

            Text(
              '패스 $passCount',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: totalCount,
              itemBuilder: (context, index) {
                final isCurrent = index == currentIndex;
                final isChecked = checkedIndices.contains(index);
                final isPassed = passedIndices.contains(index);

                String mark = '□';

                if (isChecked) mark = '✔';
                if (isPassed) mark = 'P';
                if (isCurrent) mark = '▶';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '$mark ${index + 1}',
                    style: TextStyle(
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}