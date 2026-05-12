// lib/screens/memo_edit_screen.dart

import 'package:flutter/material.dart';
import '../models/checkpoint.dart';
import '../services/memo_service.dart';

class MemoEditScreen extends StatefulWidget {
  final List<Checkpoint> points;

  const MemoEditScreen({
    super.key,
    required this.points,
  });

  @override
  State<MemoEditScreen> createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  final Map<int, TextEditingController> controllers = {};
  final Map<int, String> loadedMemos = {};

  @override
  void initState() {
    super.initState();
    loadAllMemos();
  }

  Future<void> loadAllMemos() async {
    for (final point in widget.points) {
      final memo = await MemoService.loadMemo(point.id);

      loadedMemos[point.id] = memo;
      controllers[point.id] = TextEditingController(text: memo);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> saveMemo(Checkpoint point) async {
    final text = controllers[point.id]?.text.trim() ?? '';

    await MemoService.saveMemo(point.id, text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('(${point.id}) ${point.name} 메모 저장됨'),
      ),
    );
  }

  Future<void> deleteMemo(Checkpoint point) async {
    await MemoService.deleteMemo(point.id);

    controllers[point.id]?.clear();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('(${point.id}) ${point.name} 메모 삭제됨'),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controllers.length != widget.points.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('메모 편집'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 편집'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.points.length,
        itemBuilder: (context, index) {
          final point = widget.points[index];
          final controller = controllers[point.id]!;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(${point.id}) ${point.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    point.description.isEmpty ? '기본 설명 없음' : point.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '개인 메모',
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => saveMemo(point),
                          child: const Text('저장'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => deleteMemo(point),
                          child: const Text('삭제'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}