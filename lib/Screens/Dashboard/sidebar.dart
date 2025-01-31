import 'dart:developer';
import 'package:adminpannal/Screens/Dashboard/project_card.dart';
import 'package:adminpannal/Screens/Dashboard/selection_bottom.dart';
import 'package:adminpannal/Screens/Dashboard/upgrade_premium_card.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final int screenIndex;
  final Function(int) onScreenSelected;

  const Sidebar({
    super.key,
    required this.screenIndex,
    required this.onScreenSelected,
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
                  projectName: "Krishi Seva Kendra Admin",
                  releaseTime: DateTime(2024, 1, 31),
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
                  label: "Banner Images",
                ),
                SelectionButtonData(
                  activeIcon: Icons.energy_savings_leaf,
                  icon: Icons.energy_savings_leaf_outlined,
                  label: "Crops",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.activity,
                  icon: EvaIcons.activityOutline,
                  label: "Home Layout",
                ),
                SelectionButtonData(
                  activeIcon: Icons.discount,
                  icon: Icons.discount_outlined,
                  label: "Discount Coupons",
                ),
                SelectionButtonData(
                  activeIcon: Icons.pages,
                  icon: Icons.pages_rounded,
                  label: "Product Between Banners",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.headphones,
                  icon: EvaIcons.headphonesOutline,
                  label: "Agri Advisor",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.archive,
                  icon: EvaIcons.archiveOutline,
                  label: "Notifications",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: "Developers",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  label: "Support",
                ),
                SelectionButtonData(
                  activeIcon: Icons.logout,
                  icon: Icons.logout_outlined,
                  label: "Log Out",
                ),
              ],
              onSelected: (index, value) {
                widget.onScreenSelected(index);
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
