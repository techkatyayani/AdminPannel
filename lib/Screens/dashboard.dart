import 'dart:developer';

import 'package:adminpannal/Screens/Banners.dart';
import 'package:adminpannal/Screens/CropScreen.dart';
import 'package:adminpannal/Screens/header.dart';
import 'package:adminpannal/Screens/project_card.dart';
import 'package:adminpannal/Screens/selection_bottom.dart';
import 'package:adminpannal/Screens/sidebar.dart';
import 'package:adminpannal/Screens/upgrade_premium_card.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

int screenIndex = 0;

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  List<Widget> screens = [
    const BannerScreen(),
    const Center(
      child: Text("Notification Screen"),
    ),
    const CropScreen(),
    const Center(
      child: Text("Admin Screen"),
    ),
    const Center(
      child: Text("Others Screen"),
    ),
    const Center(
      child: Text("Support Screen"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : const Drawer(
              child: Padding(
                padding: EdgeInsets.only(top: krishiSpacing),
                child: Sidebar(),
              ),
            ),
      body: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: krishiSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                onPressedMenu: () {
                  openDrawer();
                },
              ),
              screens[screenIndex],
            ]),
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 4 : 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(krishiBorderRadius),
                    bottomRight: Radius.circular(krishiBorderRadius),
                  ),
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: krishiSpacing),
                          Padding(
                            padding: const EdgeInsets.all(krishiSpacing),
                            child: ProjectCard(
                              data: ProjectCardData(
                                projectImage:
                                    const AssetImage("assets/images/logo1.png"),
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
                                label: "Banner Images",
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.archive,
                                icon: EvaIcons.archiveOutline,
                                label: "Notifications",
                              ),
                              SelectionButtonData(
                                activeIcon: Icons.energy_savings_leaf,
                                icon: Icons.energy_savings_leaf_outlined,
                                label: "Crops",
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
                            backgroundColor:
                                Theme.of(context).canvasColor.withOpacity(.4),
                            onPressed: () {},
                          ),
                          const SizedBox(height: krishiSpacing),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 13,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: krishiSpacing * (kIsWeb ? 1 : 2)),
                      _buildHeader(),
                      screens[screenIndex],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: krishiSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: krishiSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          const Expanded(child: Header()),
        ],
      ),
    );
  }
}
