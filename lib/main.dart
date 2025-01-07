import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/common/database/connection/sqlite_db_connection.dart';
import 'package:task_planner/controllers/create_task_controller.dart';
import 'package:task_planner/controllers/home_controller.dart';
import 'package:task_planner/infra/repositories/task_repository_impl.dart';
import 'package:task_planner/models/task_model.dart';
import 'package:task_planner/pages/calendar_page.dart';
import 'package:task_planner/pages/create_task_page.dart';
import 'package:task_planner/pages/home_page.dart';
import 'package:task_planner/repositories/task_repository.dart';
import 'package:task_planner/splash_page.dart';
import 'package:task_planner/theme/colors/light_colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow,
    statusBarColor: Color(0xffffb969),
  ));

  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => SqliteDbConnection.get()),
          Provider<TaskRepository>(
            create: (context) => TaskRepositoryImpl(connection: context.read()),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeController(taskRepository: context.read()),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                CreateTaskController(taskRepository: context.read()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: LightColors.kDarkBlue,
                  displayColor: LightColors.kDarkBlue,
                  fontFamily: 'Poppins',
                ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/create-task':
                return MaterialPageRoute<TaskModel>(
                  builder: (context) => const CreateTaskPage(),
                );
              case '/home':
                return MaterialPageRoute(
                  builder: (context) => const HomePage(),
                );
              case '/calendar':
                return MaterialPageRoute(
                  builder: (context) => const CalendarPage(),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => const SplashPage(),
                );
            }
          },
        ));
  }
}
