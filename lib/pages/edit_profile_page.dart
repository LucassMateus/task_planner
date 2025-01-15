import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_planner/common/widgets/profile_widget.dart';
import 'package:task_planner/models/profile_model.dart';
import 'package:task_planner/common/theme/colors/light_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final ProfileModel profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ProfileModel get profile => widget.profile;

  final imagePicker = ImagePicker();
  File? imageFile;

  late final TextEditingController nameEC;
  late final TextEditingController occupationEC;

  Future<void> pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    nameEC = TextEditingController(text: profile.name);
    occupationEC = TextEditingController(text: profile.occupation);
    if (profile.imagePath != null) imageFile = File(profile.imagePath!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: LightColors.kDarkYellow,
        actions: [
          IconButton(
            onPressed: () {
              final result = ProfileModel(
                name: nameEC.text,
                occupation: occupationEC.text,
                imagePath: imageFile?.path,
              );

              Navigator.pop(context, result);
            },
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      backgroundColor: LightColors.kLightYellow,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage: imageFile != null //
                      ? FileImage(imageFile!)
                      : profile.image,
                  backgroundColor: LightColors.kLightYellow2,
                  child: imageFile == null
                      ? ProfileWidget.emptyImage(profile.name)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTap: _showOpcoesBottomSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Edit Photo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameEC,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    controller: occupationEC,
                    decoration: const InputDecoration(
                      labelText: 'Occupation',
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

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      backgroundColor: LightColors.kLightYellow,
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: LightColors.kLightYellow2,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: LightColors.kDarkBlue,
                    ),
                  ),
                ),
                title: Text(
                  'Gallery',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: LightColors.kLightYellow2,
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: LightColors.kDarkBlue,
                    ),
                  ),
                ),
                title: Text(
                  'Camera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: LightColors.kLightYellow2,
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: LightColors.kDarkBlue,
                    ),
                  ),
                ),
                title: Text(
                  'Remove',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
