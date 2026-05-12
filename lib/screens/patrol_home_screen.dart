// lib/screens/patrol_home_screen.dart

import 'package:flutter/material.dart';
import '../data/checkpoint_data.dart';
import '../models/checkpoint.dart';
import '../utils/patrol_helpers.dart';
import '../widgets/checkpoint_card.dart';
import '../widgets/control_buttons.dart';
import '../widgets/guide_popup.dart';
import '../widgets/milestone_panel.dart';
import '../widgets/move_point_dialog.dart';
import '../services/memo_service.dart';
import 'memo_edit_screen.dart';

class PatrolHomeScreen extends StatefulWidget {
  const PatrolHomeScreen({super.key});

  @override
  State<PatrolHomeScreen> createState() => _PatrolHomeScreenState();
}

class _PatrolHomeScreenState extends State<PatrolHomeScreen> {
  final List<Checkpoint> points = checkpointData;

  int currentIndex = 0;
  final Set<int> checkedIndices = {};
  final Set<int> passedIndices = {};

  final Map<int, String> memoMap = {};

  Checkpoint? get previousPoint => safePointAt(points, currentIndex - 1);
  Checkpoint? get currentPoint => safePointAt(points, currentIndex);
  Checkpoint? get nextPoint => safePointAt(points, currentIndex + 1);
  Checkpoint? get nextNextPoint => safePointAt(points, currentIndex + 2);

  @override
  void initState() {
    super.initState();
    loadVisibleMemos();
  }

  Future<void> loadVisibleMemos() async {
    final visiblePoints = [
      previousPoint,
      currentPoint,
      nextPoint,
      nextNextPoint,
    ].whereType<Checkpoint>();

    for (final point in visiblePoints) {
      memoMap[point.id] = await MemoService.loadMemo(point.id);
    }

    if (mounted) {
      setState(() {});
    }
  }

  String? memoFor(Checkpoint? point) {
    if (point == null) return null;
    return memoMap[point.id];
  }

  void moveNext({required bool checked}) {
    if (currentPoint == null) return;

    if (checked) {
      checkedIndices.add(currentIndex);
      passedIndices.remove(currentIndex);
    } else {
      passedIndices.add(currentIndex);
      checkedIndices.remove(currentIndex);
    }

    if (currentIndex < points.length - 1) {
      setState(() {
        currentIndex += 1;
      });
      loadVisibleMemos();
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('마지막 포인트입니다.')),
      );
    }
  }

  Future<void> handleMovePoint() async {
    final selectedIndex = await showMovePointDialog(
      context,
      points,
      memoMap: memoMap,
    );
    if (selectedIndex == null) return;

    setState(() {
      currentIndex = selectedIndex;
    });

    await loadVisibleMemos();
  }

  Future<void> handleGuidePopup() async {
    final point = nextPoint;
    if (point == null) return;
    await showGuidePopup(context, point);
  }

  @override
  Widget build(BuildContext context) {
    final total = points.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('순찰 보조'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MemoEditScreen(points: points),
                ),
              );

              await loadVisibleMemos();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CheckpointCard(
                          title: '이전',
                          checkpoint: previousPoint,
                          memo: memoFor(previousPoint),
                        ),
                        CheckpointCard(
                          title: '현재',
                          checkpoint: currentPoint,
                          isCurrent: true,
                          memo: memoFor(currentPoint),
                        ),
                        CheckpointCard(
                          title: '다음',
                          checkpoint: nextPoint,
                          onLongPress: handleGuidePopup,
                          memo: memoFor(nextPoint),
                        ),
                        CheckpointCard(
                          title: '다다음',
                          checkpoint: nextNextPoint,
                          memo: memoFor(nextNextPoint),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ControlButtons(
                    onCheck: () => moveNext(checked: true),
                    onPass: () => moveNext(checked: false),
                    onMove: handleMovePoint,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            MilestonePanel(
              totalCount: total,
              currentIndex: currentIndex,
              checkedIndices: checkedIndices,
              passedIndices: passedIndices,
            ),
          ],
        ),
      ),
    );
  }
}