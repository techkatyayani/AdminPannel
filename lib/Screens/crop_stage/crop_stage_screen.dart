import 'dart:typed_data';

import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:adminpannal/Screens/crop_stage/widgets/add_activity_dialog.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/image_upload_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'widgets/add_stage_dialog.dart';
import 'widgets/crop_activity_card.dart';

class CropStageScreen extends StatefulWidget {

  final String cropName;
  final String cropId;

  const CropStageScreen({super.key, required this.cropName, required this.cropId});

  @override
  State<CropStageScreen> createState() => _CropStageScreenState();
}

class _CropStageScreenState extends State<CropStageScreen> {

  late CropStageProvider provider;

  @override
  void initState() {
    super.initState();

    provider = Provider.of<CropStageProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.fetchCropStages(cropId: widget.cropId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.cropName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<CropStageProvider>(
        builder: (BuildContext context, CropStageProvider provider, Widget? child) {
          if (provider.isFetchingStages) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (provider.stages.isEmpty) {
            return const Center(
              child: Text(
                'No Stages Found..!!\n\nTap + to Add Stage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: provider.stages.length,
            itemBuilder: (context, stageIndex) {

              Stage stage = provider.stages[stageIndex];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Stage Name
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 20),
                    color: Colors.orange.shade300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          stage.stageName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),

                        InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Consumer<CropStageProvider>(
                                  builder: (BuildContext context, CropStageProvider provider, Widget? child) {
                                    return ImageUploadDialog(
                                        pickedImage: provider.pickedStageIcon,
                                        imageUrl: stage.stageIcon == '' ? null : stage.stageIcon,
                                        onTap: () async {
                                          Uint8List? image = await provider.pickImage();
                                          if (image != null) {
                                            provider.setPickedStageIcon(image);
                                          }
                                        },
                                        onUpload: () async {
                                          if (provider.pickedStageIcon != null) {

                                            Utils.showLoadingBox(context: context, title: 'Uploading Image...');

                                            String imageId = DateTime.now().millisecondsSinceEpoch.toString();

                                            String? url = await provider.uploadImage(
                                                file: provider.pickedStageIcon!,
                                                path: 'crop_stage_activities/${widget.cropId}/${stage.stageId}_$imageId'
                                            );

                                            Navigator.pop(context);

                                            if (url != null) {

                                              Utils.showLoadingBox(context: context, title: 'Saving Image...');

                                              bool isSaved = await provider.updateStageImage(
                                                cropId: widget.cropId,
                                                stageId: stage.stageId,
                                                imageUrl: url,
                                              );

                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              if (isSaved) {
                                                Utils.showSnackBar(context: context, message: 'Image Saved Successfully..!!');
                                              } else {
                                                Utils.showSnackBar(context: context, message: 'An error occured while saving image..!!');
                                              }

                                            } else {
                                              Navigator.pop(context);
                                              Utils.showSnackBar(context: context, message: 'An error occured while uploading image..!!');
                                            }
                                          } else {
                                            Navigator.pop(context);
                                            Utils.showSnackBar(context: context, message: 'Please select image to upload..!!');
                                          }
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                          provider.setPickedStageIcon(null);
                                        }
                                    );
                                  },
                                );
                              }
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.orange,
                                width: 3,
                              ),
                            ),
                            child: Image.network(
                              stage.stageIcon,
                              height: 25,
                              width: 25,
                              errorBuilder: (context, error, stace) {
                                return const FaIcon(
                                  FontAwesomeIcons.pagelines,
                                  color: Colors.orange
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Stage Activities
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stage.activities.length + 1,
                    itemBuilder: (context, index) {

                      if (index == stage.activities.length) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 15),
                          child: Row(
                            children: [
                              customAddIcon(
                                onTap: () {
                                  showAddActivityDialog(
                                    context: context,
                                    cropId: widget.cropId,
                                    stageId: stage.stageId,
                                    activityId: 'activity_${stage.activities.length + 1}',
                                    showDurationField: true,
                                  );
                                },
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.1 + 110,
                                hideColor: true
                              ),
                            ],
                          ),
                        );
                      }

                      Activities activities = stage.activities[index];

                      return Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Activity Duration
                            Text(
                              'Duration - ${activities.duration} Days',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.1 + 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: activities.activity.length + 1,
                                itemBuilder: (context, activityIndex) {

                                  if (activityIndex == activities.activity.length) {
                                    return customAddIcon(
                                      onTap: () {
                                        showAddActivityDialog(
                                          context: context,
                                          cropId: widget.cropId,
                                          stageId: stage.stageId,
                                          activityId: 'activity_${index+1}',
                                          showDurationField: false,
                                        );
                                      },
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      height: MediaQuery.of(context).size.width * 0.1,
                                    );
                                  }

                                  return CropActivityCard(
                                    cropId: widget.cropId,
                                    stageId: stage.stageId,
                                    activity: activities.activity[activityIndex],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),

                ],
              );
            }
          );
        },
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          showAddStageDialog(
            context: context,
            cropId: widget.cropId,
          );
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        )
      ),
    );
  }

  Widget customAddIcon({
    required VoidCallback onTap,
    required double width,
    required double height,
    bool hideColor = false,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: hideColor ? Colors.transparent : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(
              BorderSide(
                color: !hideColor ? Colors.transparent : Colors.grey.shade200,
                width: !hideColor ? 2 : 0,
              ),
            )
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: hideColor ? Colors.grey.shade200 : Colors.black,
              size: MediaQuery.of(context).size.width * 0.025,
            ),
          ),
        ),
      ),
    );
  }
}
