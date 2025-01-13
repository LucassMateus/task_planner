import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/common/widgets/search_widget.dart';
import 'package:task_planner/common/widgets/task_card.dart';
import 'package:task_planner/controllers/home_controller.dart';
import 'package:task_planner/models/task_model.dart';
import 'package:task_planner/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:task_planner/common/widgets/task_column.dart';
import 'package:task_planner/common/widgets/top_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Widget calendarIcon({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: const CircleAvatar(
        radius: 25.0,
        backgroundColor: LightColors.kGreen,
        child: Icon(
          Icons.calendar_today,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget addIcon({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: const CircleAvatar(
        radius: 25.0,
        backgroundColor: LightColors.kGreen,
        child: Icon(
          Icons.add,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<HomeController>(context, listen: false);
    controller.addListener(_listener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.init();
    });
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    super.dispose();
  }

  _listener() {
    if (controller.taskState == HomeState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () async {
              await controller.init();
            },
          ),
        ),
      );
    }
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: [
            TopContainer(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularPercentIndicator(
                            radius: 90.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: 0.75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: LightColors.kRed,
                            backgroundColor: LightColors.kDarkYellow,
                            center: const CircleAvatar(
                              backgroundColor: LightColors.kBlue,
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                'assets/images/avatar.png',
                              ),
                            ),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Lucas Mateus',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: LightColors.kDarkBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'App Developer',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              subheading('My Tasks'),
                              const Spacer(),
                              HomePage.calendarIcon(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/calendar');
                                },
                              ),
                              const SizedBox(width: 8.0),
                              HomePage.addIcon(
                                onTap: () async {
                                  final results = await Navigator.of(context)
                                      .pushNamed<TaskModel>('/create-task');

                                  if (results != null) {
                                    controller.addTasks([results]);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          ListenableBuilder(
                            listenable: controller,
                            builder: (context, child) {
                              return Column(
                                children: controller.taskStatusCount.entries
                                    .map((task) => TaskColumn(
                                          status: task.key,
                                          quantity: task.value,
                                        ))
                                    .toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(thickness: 2),
                    ),
                    SearchWidget(onSearch: (text, status, date) async {
                      await controller.filterTasks(text, status, date);
                    }),
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5.0),
                          ListenableBuilder(
                            listenable: controller,
                            builder: (context, child) {
                              return Column(
                                children: controller.tasks
                                    .map((e) => TaskCard(
                                          task: e,
                                          onTap: controller.updateTaskStatus,
                                        ))
                                    .toList(),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
