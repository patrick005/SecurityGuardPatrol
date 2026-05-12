// lib/utils/patrol_helpers.dart
import '../models/checkpoint.dart';

Checkpoint? safePointAt(List<Checkpoint> points, int index) {
  if (index < 0 || index >= points.length) return null;
  return points[index];
}