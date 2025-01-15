import 'package:flutter/material.dart';
import 'package:task_planner/common/theme/colors/light_colors.dart';

class TaskCategoryChip extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const TaskCategoryChip({
    super.key,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<TaskCategoryChip> createState() => _TaskCategoryChipState();
}

class _TaskCategoryChipState extends State<TaskCategoryChip> {
  String get text => widget.text;
  bool get isSelected => widget.isSelected;
  VoidCallback? get onTap => widget.onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(text),
      backgroundColor: isSelected ? LightColors.kRed : Colors.white,
      labelStyle: isSelected
          ? const TextStyle(color: Colors.white)
          : const TextStyle(color: LightColors.kDarkBlue),
      onPressed: () => onTap?.call(),
    );
  }
}
