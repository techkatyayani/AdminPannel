import 'dart:developer';

import 'package:adminpannal/Screens/dashboard.dart';
import 'package:adminpannal/Screens/project_card.dart';
import 'package:adminpannal/Screens/selection_bottom.dart';
import 'package:adminpannal/Screens/upgrade_premium_card.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({
    super.key,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            const SizedBox(height: krishiSpacing),
            Padding(
              padding: const EdgeInsets.all(krishiSpacing),
              child: ProjectCard(
                data: ProjectCardData(
                  projectImage: const AssetImage("assets/images/logo1.png"),
                  projectName: "Katyayani Admin",
                  releaseTime: DateTime.now(),
                  percent: .3,
                ),
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: krishiSpacing),
            SelectionButton(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.grid,
                  icon: EvaIcons.gridOutline,
                  label: "Dashboard",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.archive,
                  icon: EvaIcons.archiveOutline,
                  label: "Banner Images",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: "Users",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.activity,
                  icon: EvaIcons.activityOutline,
                  label: "Admin",
                  // totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: "Others",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  label: "Support",
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  screenIndex = index;
                });
                log("index : $index | label : ${value.label}");
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: krishiSpacing),
            UpgradePremiumCard(
              backgroundColor: Theme.of(context).canvasColor.withOpacity(.4),
              onPressed: () {},
            ),
            const SizedBox(height: krishiSpacing),
          ],
        ),
      ),
    );
  }
}
