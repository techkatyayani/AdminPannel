import 'dart:developer';
import 'package:adminpannal/Screens/Agri%20Advisor/agriAdvisorScreen.dart';
import 'package:adminpannal/Screens/Banner/Banners.dart';
import 'package:adminpannal/Screens/Coupons/discountCoupons.dart';
import 'package:adminpannal/Screens/Crops/cropScreen.dart';
import 'package:adminpannal/Screens/Dashboard/header.dart';
import 'package:adminpannal/Screens/Dashboard/project_card.dart';
import 'package:adminpannal/Screens/Dashboard/selection_bottom.dart';
import 'package:adminpannal/Screens/Dashboard/upgrade_premium_card.dart';
import 'package:adminpannal/Screens/HomeLayout/home_rearrange_screen.dart';
import 'package:adminpannal/Screens/Krishi%20News/krishi_news_screen.dart';
import 'package:adminpannal/Screens/Log%20Out/logoutScreen.dart';
import 'package:adminpannal/Screens/Others/others_screen.dart';
import 'package:adminpannal/Screens/ProductBetweenBanners/ProductBetweenBanners.dart';
import 'package:adminpannal/Screens/Sale/saleScreen.dart';
import 'package:adminpannal/Screens/Soil&Water%20Testing/soilAndwaterTesting.dart';
import 'package:adminpannal/Screens/Support/support_screen.dart';
import 'package:adminpannal/Screens/Youtube/youtube_videos_screen.dart';
import 'package:adminpannal/Screens/prouct_catagory/product_catagory_screen.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Category/category_screen.dart';
import '../Notification/notification_screen.dart';
import '../product_review/all_review_screen.dart';

int screenIndex = 0;

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSidebarExpanded = true;
  int screenIndex = 9;

  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  List<Widget> screens = [
    const HomeRearrangeScreen(),
    const BannerScreen(),
    const ProductBetweenBanners(),
    const SaleScreen(),
    const CropScreen(),
    const DiscountCoupons(),
    const CategoryScreen(),
    const ProductCatagoryScreen(),
    const AllReviewScreen(),
    const KrishiNewsScreen(),
    const SoilAndWaterTesting(),
    const AgriAdvisorScreen(),
    const YoutubeVideosScreen(),
    const NotificationScreen(),
    const ImageUploadScreen(),
    const SupportScreen(),
    const LogoutScreen()
  ];

  List<SelectionButtonData> getSelectionButtons() {
    List<SelectionButtonData> list = [
      SelectionButtonData(
        activeIcon: EvaIcons.activity,
        icon: EvaIcons.activityOutline,
        label: "Home Rearrange",
      ),
      SelectionButtonData(
        activeIcon: EvaIcons.grid,
        icon: EvaIcons.gridOutline,
        label: "Banner Images",
      ),
      SelectionButtonData(
        activeIcon: Icons.pages,
        icon: Icons.pages_rounded,
        label: "Product Between Banners",
      ),
      SelectionButtonData(
        activeIcon: Icons.card_giftcard,
        icon: Icons.card_giftcard_outlined,
        label: "KSK Sale",
      ),
      SelectionButtonData(
        activeIcon: Icons.energy_savings_leaf,
        icon: Icons.energy_savings_leaf_outlined,
        label: "Crops",
      ),
      SelectionButtonData(
        activeIcon: Icons.discount,
        icon: Icons.discount_outlined,
        label: "Discount Coupons",
      ),
      SelectionButtonData(
        activeIcon: Icons.category,
        icon: Icons.category_outlined,
        label: "Top Category Row",
      ),
      SelectionButtonData(
        activeIcon: Icons.shopping_cart,
        icon: Icons.shopping_cart_outlined,
        label: "Product Categories",
      ),
      SelectionButtonData(
        activeIcon: EvaIcons.image,
        icon: EvaIcons.imageOutline,
        label: "Product Reviews",
      ),
      SelectionButtonData(
        activeIcon: Icons.feed_sharp,
        icon: Icons.feed_outlined,
        label: "Krishi News",
      ),
      SelectionButtonData(
        activeIcon: Icons.adjust_sharp,
        icon: Icons.adjust,
        label: "Soil & Water Testing",
      ),
      SelectionButtonData(
        activeIcon: EvaIcons.headphones,
        icon: EvaIcons.headphonesOutline,
        label: "Agri Advisor",
      ),
      SelectionButtonData(
        activeIcon: FontAwesomeIcons.youtube,
        icon: FontAwesomeIcons.squareYoutube,
        label: "Youtube Links",
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
    ];

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: krishiSpacing),
                        Padding(
                          padding: const EdgeInsets.all(krishiSpacing),
                          child: ProjectCard(
                            data: ProjectCardData(
                              projectImage: const AssetImage(
                                  "assets/images/launchicon.png"),
                              projectName: "Krishi Seva Kendra",
                              releaseTime: DateTime.now(),
                              percent: .3,
                            ),
                          ),
                        ),
                        const Divider(thickness: 1),
                        const SizedBox(height: krishiSpacing),
                        SelectionButton(
                          data: getSelectionButtons(),
                          onSelected: (index, value) {
                            setState(() {
                              screenIndex = index;
                            });
                            Navigator.of(context).pop();
                          },
                          initialSelected: screenIndex,
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
                ],
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSidebarExpanded ? 250 : 60,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(krishiBorderRadius),
                    bottomRight: Radius.circular(krishiBorderRadius),
                  ),
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: krishiSpacing),
                                Padding(
                                  padding: const EdgeInsets.all(krishiSpacing),
                                  child: ProjectCard(
                                    data: ProjectCardData(
                                      projectImage: const AssetImage(
                                          "assets/images/launchicon.png"),
                                      projectName: "Krishi Seva Kendra",
                                      releaseTime: DateTime.now(),
                                      percent: .8,
                                    ),
                                  ),
                                ),
                                const Divider(thickness: 1),
                                const SizedBox(height: krishiSpacing),
                                SelectionButton(
                                  data: getSelectionButtons(),
                                  onSelected: (index, value) {
                                    setState(() {
                                      screenIndex = index;
                                    });
                                  },
                                  initialSelected: screenIndex,
                                ),
                                const Divider(thickness: 1),
                                const SizedBox(height: krishiSpacing),
                                UpgradePremiumCard(
                                  backgroundColor: Theme.of(context)
                                      .canvasColor
                                      .withOpacity(.4),
                                  onPressed: () {},
                                ),
                                const SizedBox(height: krishiSpacing),
                              ],
                            ),
                          ),
                        ),
                      ],
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
