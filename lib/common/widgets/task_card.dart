import 'package:flutter/material.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/models/task_model.dart';
import 'package:task_planner/theme/colors/light_colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final TaskModel task;
  final void Function(TaskModel task, TaskStatus status)? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: LightColors.kLightYellow,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: LightColors.kBlue,
                ),
                const SizedBox(width: 4.0),
                Text(
                  task.date.toLocal().toString().split(' ')[0],
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {},
            icon: PopupMenuButton<TaskStatus>(
              color: LightColors.kLightYellow,
              icon: Icon(task.status.icon, color: task.status.color),
              itemBuilder: (context) {
                return TaskStatus.values.map((e) {
                  return PopupMenuItem<TaskStatus>(
                    onTap: () => onTap?.call(task, e),
                    child: Row(
                      children: [
                        Icon(e.icon, color: e.color),
                        const SizedBox(width: 8.0),
                        Text(e.text),
                      ],
                    ),
                  );
                }).toList();
              },
            )),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description, size: 18),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        task.description,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 4.0),
                    Text(
                      '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.category, size: 18),
                    const SizedBox(width: 4.0),
                    Text(
                      'Categoria: ${task.category.text}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                /// Botão de Ação (ex.: Alterar Status)
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: PopupMenuButton<TaskStatus>(
                //     icon: const Icon(Icons.more_vert),
                //     itemBuilder: (context) {
                //       return TaskStatus.values.map((e) {
                //         return PopupMenuItem<TaskStatus>(
                //           onTap: () => onTap?.call(task, e),
                //           child: Row(
                //             children: [
                //               Icon(e.icon, color: e.color),
                //               const SizedBox(width: 8.0),
                //               Text(e.text),
                //             ],
                //           ),
                //         );
                //       }).toList();
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
