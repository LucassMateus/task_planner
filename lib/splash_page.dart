import 'package:flutter/material.dart';
import 'package:task_planner/common/database/config/data_base_config.dart';
import 'package:task_planner/common/services/notification_service.dart';
import 'package:task_planner/infra/migrations/migration_v1.dart';
import 'package:task_planner/common/theme/colors/light_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() async {
    final nav = Navigator.of(context);

    DataBaseConfig.initialize(
      name: 'task_planner',
      version: 1,
      migrations: [MigrationV1()],
    );

    await NotificationService.init();

    nav.pushReplacementNamed('/home');

    // final db = await SqliteDbConnection.get().open();
    // await db.delete('tasks');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
