import 'dart:developer';
import 'package:adminpannal/Screens/Banner/Banners.dart';
import 'package:adminpannal/Screens/Coupons/discountCoupons.dart';
import 'package:adminpannal/Screens/Crops/cropScreen.dart';
import 'package:adminpannal/Screens/Dashboard/header.dart';
import 'package:adminpannal/Screens/HomeLayout/productCollectionScreen.dart';
import 'package:adminpannal/Screens/Dashboard/project_card.dart';
import 'package:adminpannal/Screens/Dashboard/selection_bottom.dart';
import 'package:adminpannal/Screens/Dashboard/sidebar.dart';
import 'package:adminpannal/Screens/Dashboard/upgrade_premium_card.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Notification/notification_screen.dart';

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
    const CropScreen(),
    const ProductCollectionScreen(),
    const NotificationScreen(),
    const DiscountCoupons(),
    const Center(
      child: Text("Comming Soon"),
    ),
    const Center(
      child: Text("Comming Soon"),
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
                                activeIcon: Icons.energy_savings_leaf,
                                icon: Icons.energy_savings_leaf_outlined,
                                label: "Crops",
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.activity,
                                icon: EvaIcons.activityOutline,
                                label: "Home Layout",
                                // totalNotif: 20,
                              ),
                              SelectionButtonData(
                                activeIcon: EvaIcons.archive,
                                icon: EvaIcons.archiveOutline,
                                label: "Notifications",
                              ),
                              SelectionButtonData(
                                activeIcon: Icons.discount_outlined,
                                icon: Icons.discount_outlined,
                                label: "Discount Coupons",
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
