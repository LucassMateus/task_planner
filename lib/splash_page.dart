import 'package:flutter/material.dart';
import 'package:task_planner/common/database/config/data_base_config.dart';
import 'package:task_planner/common/database/connection/sqlite_db_connection.dart';
import 'package:task_planner/common/services/notification_service.dart';
import 'package:task_planner/infra/migrations/migration_v1.dart';
import 'package:task_planner/theme/colors/light_colors.dart';

import 'common/services/background_notification_service.dart';

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
    DataBaseConfig.initialize(
      name: 'task_planner',
      version: 1,
      migrations: [MigrationV1()],
    );

    await NotificationService.init();

    Navigator.of(context).pushReplacementNamed('/home');

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
