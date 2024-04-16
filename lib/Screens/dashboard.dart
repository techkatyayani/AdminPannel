import 'package:adminpannal/Screens/Banners.dart';
import 'package:adminpannal/Screens/header.dart';
import 'package:adminpannal/Screens/sidebar.dart';
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
      child: Text("Home Screen"),
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
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: krishiSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
              onPressedMenu: () {
                openDrawer();
              },
            ),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: const Column(
                  children: [],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: krishiSpacing * (kIsWeb ? 1 : 2)),
                    _buildHeader(onPressedMenu: () {
                      openDrawer();
                    }),
                  ],
                ),
              )
            ],
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 4 : 3,
                child: const ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(krishiBorderRadius),
                    bottomRight: Radius.circular(krishiBorderRadius),
                  ),
                  child: Sidebar(),
                ),
              ),
              Flexible(
                flex: 9,
                child: Column(
                  children: [
                    const SizedBox(height: krishiSpacing * (kIsWeb ? 1 : 2)),
                    _buildHeader(),
                    screens[screenIndex],
                  ],
                ),
              ),
              // Flexible(
              //   flex: 9,
              //   child: Column(
              //     children: [
              //       const SizedBox(height: krishiSpacing * (kIsWeb ? 1 : 2)),
              //       _buildHeader(),
              //     ],
              //   ),
              // ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [],
                ),
              )
            ],
          );
        },
      )),
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
