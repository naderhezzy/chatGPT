// ignore_for_file: avoid_classes_with_only_static_members

import 'package:ai_bot/constants/constants.dart';
import 'package:ai_bot/widgets/models_drop_down.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Ai Model"),
              ModelsDropDownWidget(),
            ],
          ),
        );
      },
    );
  }
}
