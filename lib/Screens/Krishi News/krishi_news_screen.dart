import 'dart:developer';

import 'package:adminpannal/Screens/Krishi%20News/krishi_news_images.dart';
import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/Screens/Krishi%20News/krishi_news_videos.dart';
import 'package:adminpannal/Screens/Krishi%20News/widgets/custom_post_text_field.dart';
import 'package:adminpannal/Screens/Krishi%20News/widgets/image_upload_card.dart';
import 'package:adminpannal/Screens/Krishi%20News/widgets/video_upload_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';

class KrishiNewsScreen extends StatefulWidget {
  const KrishiNewsScreen({super.key});

  @override
  State<KrishiNewsScreen> createState() => _KrishiNewsScreenState();
}

class _KrishiNewsScreenState extends State<KrishiNewsScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                color: Colors.transparent,
                height: 60,
                child: TabBar(
                  controller: _tabController,
                  labelColor: krishiPrimaryColor,
                  indicatorColor: krishiPrimaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: false,
                  physics: const NeverScrollableScrollPhysics(),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.image),
                      text: "Images"
                    ),

                    Tab(
                      icon: Icon(Icons.video_library),
                      text: "Videos"
                    ),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  clipBehavior: Clip.none,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    KrishiNewsImages(),

                    KrishiNewsVideos(),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.125,
          right: 15,
          child: InkWell(
              onTap: () {
                _showAddPostDialog(
                  context: context,
                  isVideo: _tabController.index == 0 ? false : true
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: krishiPrimaryColor,
                    shape: BoxShape.circle
                ),
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: krishiFontColorPallets[0],
                ),
              )
          ),
        ),
      ],
    );
  }

  _showAddPostDialog({
    required BuildContext context,
    required bool isVideo,
  }) {

    log('Is Video - $isVideo');

    return showDialog(
        context: context,
        builder: (context) {
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          return Form(
            key: formKey,
            child: Dialog(
              backgroundColor: krishiFontColorPallets[0],
              child: Consumer<KrishiNewsProvider>(
                  builder: (BuildContext context, KrishiNewsProvider provider, Widget? child) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        color: krishiFontColorPallets[0],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Add Post',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: krishiPrimaryColor,
                            ),
                          ),

                          const SizedBox(height: 20),

                          isVideo ? VideoUploadCard(provider: provider) : ImageUploadCard(provider: provider),

                          const SizedBox(height: 10),

                          CustomPostTextField(
                              controller: provider.authorController,
                              hintText: 'Author Name',
                              enabled: false
                          ),

                          CustomPostTextField(
                            controller: provider.titleController,
                            hintText: 'Post Title',
                          ),

                          CustomPostTextField(
                            controller: provider.captionController,
                            hintText: 'Post Caption',
                          ),

                          CustomPostTextField(
                            controller: provider.productController,
                            hintText: 'Product Id',
                          ),

                          const SizedBox(height: 40),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _customButton(
                                  onPressed: () {
                                    provider.clearPostDialog();
                                    Navigator.pop(context);
                                  },
                                  btnText: 'Cancel',
                                  textColor: Colors.black
                              ),

                              const SizedBox(width: 30),

                              _customButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      if (isVideo && (provider.postVideo != null || provider.postVideoBytes != null)) {
                                        await provider.createPost(context: context, mediaType: 'video');
                                      } else if (provider.postImage != null || provider.postImageBytes != null) {
                                        await provider.createPost(context: context, mediaType: 'image');
                                      } else {
                                       log('Something went wrong..!!');
                                      }
                                    }
                                  },
                                  btnText: 'Post',
                                  textColor: krishiPrimaryColor
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
              ),
            ),
          );
        }
    );
  }

  Widget _customButton({
    required VoidCallback onPressed,
    required String btnText,
    required Color textColor,
  }) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: Text(
          btnText,
          style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: textColor == Colors.black ? FontWeight.normal : FontWeight.bold
          ),
        )
    );
  }
}

String formatDuration(DateTime postTime) {
  Duration duration = DateTime.now().difference(postTime);
  if (duration.inMinutes < 1) {
    return '<1m ago';
  } else if (duration.inMinutes < 60) {
    return '${duration.inMinutes}m ago';
  } else if (duration.inHours < 24) {
    return '${duration.inHours}h ago';
  } else if (duration.inDays < 7) {
    return '${duration.inDays}d ago';
  } else if (duration.inDays < 30) {
    return '${(duration.inDays / 7).floor()}w ago';
  } else if (duration.inDays < 365) {
    return '${(duration.inDays / 30).floor()}mo ago';
  } else {
    return '${(duration.inDays / 365).floor()}y ago';
  }
}