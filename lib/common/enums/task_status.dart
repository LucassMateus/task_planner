import 'package:flutter/material.dart';
import 'package:task_planner/common/theme/colors/light_colors.dart';

enum TaskStatus {
  todo('To Do', Icons.alarm, LightColors.kRed),
  inProgress('In Progress', Icons.timelapse_outlined, LightColors.kDarkYellow),
  done('Done', Icons.check_circle_outline, LightColors.kBlue);

  final String text;
  final IconData icon;
  final Color color;

  const TaskStatus(this.text, this.icon, this.color);

  factory TaskStatus.fromMap(String text) {
    switch (text) {
      case 'To Do':
        return TaskStatus.todo;
      case 'In Progress':
        return TaskStatus.inProgress;
      case 'Done':
        return TaskStatus.done;
      default:
        throw Exception('Invalid TaskStatus');
    }
  }
}
