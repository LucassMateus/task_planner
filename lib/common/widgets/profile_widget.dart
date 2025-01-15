import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:task_planner/common/routes/routes.dart';
import 'package:task_planner/controllers/profile_controller.dart';
import 'package:task_planner/models/profile_model.dart';
import 'package:task_planner/common/theme/colors/light_colors.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static Widget emptyImage(String name) {
    final initialChar = name.characters.first.toUpperCase();
    return Text(
      initialChar,
      style: const TextStyle(
        fontSize: 64,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<ProfileController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
          center: Stack(children: [
            ListenableBuilder(
              listenable: controller,
              builder: (context, child) => CircleAvatar(
                radius: 60.0,
                backgroundImage: controller.profileImage,
                backgroundColor: LightColors.kLightYellow2,
                child: controller.profile.imagePath == null
                    ? ProfileWidget.emptyImage(controller.profile.name)
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: LightColors.kLightYellow,
                child: IconButton(
                  onPressed: () async {
                    final result =
                        await Navigator.of(context).pushNamed<ProfileModel>(
                      Routes.editProfile,
                      arguments: controller.profile,
                    );

                    if (result != null) {
                      await controller.updateProfile(result);
                    }
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: LightColors.kDarkBlue,
                  ),
                ),
              ),
            ),
          ]),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  controller.profile.name,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 22.0,
                    color: LightColors.kDarkBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  controller.profile.occupation,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
