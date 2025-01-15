import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/common/enums/task_category.dart';
import 'package:task_planner/common/widgets/picker.dart';
import 'package:task_planner/common/widgets/task_category_chip.dart';
import 'package:task_planner/controllers/create_task_controller.dart';
import 'package:task_planner/common/theme/colors/light_colors.dart';
import 'package:task_planner/common/widgets/top_container.dart';
import 'package:task_planner/common/widgets/back_button.dart';
import 'package:task_planner/common/widgets/my_text_field.dart';
import 'package:task_planner/pages/home_page.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final titleEC = TextEditingController();
  final dateEC = TextEditingController();
  final startTimeEC = TextEditingController();
  final endTimeEC = TextEditingController();
  final descriptionEC = TextEditingController();
  TaskCategory? selectedCategory;
  late final CreateTaskController taskController;

  @override
  void initState() {
    super.initState();
    taskController = Provider.of<CreateTaskController>(context, listen: false);
    taskController.addListener(_listener);
  }

  @override
  void dispose() {
    taskController.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    switch (taskController.taskState) {
      case CreateTaskState.created:
        _showSnackBar();
        Navigator.of(context).pop(taskController.createdTask);
        break;
      case CreateTaskState.error:
        _showSnackBar();
        break;
      default:
    }
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(taskController.message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    var downwardIcon = const Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopContainer(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: [
                  const MyBackButton(),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Create new task',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextField(
                        label: 'Title',
                        controller: titleEC,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Picker.showDate(
                              label: 'Date',
                              controller: dateEC,
                            ),
                          ),
                          HomePage.calendarIcon(),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Picker.showTime(
                          label: 'Start Time',
                          icon: downwardIcon,
                          controller: startTimeEC,
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Picker.showTime(
                          label: 'End Time',
                          icon: downwardIcon,
                          controller: endTimeEC,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    label: 'Description',
                    minLines: 3,
                    maxLines: 3,
                    controller: descriptionEC,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          runSpacing: 0,
                          spacing: 10.0,
                          children: TaskCategory.values
                              .map((e) => TaskCategoryChip(
                                    text: e.text,
                                    isSelected: selectedCategory == e,
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = e;
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            SizedBox(
              height: 80,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    width: width - 40,
                    decoration: BoxDecoration(
                      color: LightColors.kBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        //TODO: Check form are valid
                        await taskController.addTask(
                          title: titleEC.text,
                          date: dateEC.text,
                          startTime: startTimeEC.text,
                          endTime: endTimeEC.text,
                          description: descriptionEC.text,
                          category: selectedCategory!,
                        );
                      },
                      child: const Text(
                        'Create Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
