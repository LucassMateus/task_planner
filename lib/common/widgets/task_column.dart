import 'package:flutter/material.dart';
import 'package:task_planner/common/enums/task_status.dart';

class TaskColumn extends StatelessWidget {
  final TaskStatus status;
  final int quantity;

  const TaskColumn({super.key, required this.status, required this.quantity});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: status.color,
          child: Icon(
            status.icon,
            size: 15.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              status.text,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$quantity tasks now',
              style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45),
            ),
          ],
        )
      ],
    );
  }
}
