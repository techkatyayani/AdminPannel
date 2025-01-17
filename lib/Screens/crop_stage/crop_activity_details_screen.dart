import 'dart:typed_data';

import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CropActivityDetailsScreen extends StatefulWidget {

  final String cropId;
  final String stageId;
  final Activity activity;

  const CropActivityDetailsScreen({
    super.key,
    required this.cropId,
    required this.stageId,
    required this.activity,
  });

  @override
  State<CropActivityDetailsScreen> createState() => _CropActivityDetailsScreenState();
}

class _CropActivityDetailsScreenState extends State<CropActivityDetailsScreen> {

  late CropStageProvider provider;

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    provider = Provider.of<CropStageProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.initActivityDetails(activity: widget.activity);

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.disposeActivityDetail(disposeDuration: false);
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Consumer<CropStageProvider>(
      builder: (BuildContext context, CropStageProvider provider, Widget? child) {
        return Form(
          key: formKey,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              // title: CustomTextField(
              //   controller: provider.activityNameController,
              //   hintText: 'Activity Name',
              //   showBorders: false,
              // ),
              title: Text(
                widget.activity.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              actions: [

                ElevatedButton(
                  onPressed: () async {

                    if (provider.activityImageUrl == '' && provider.pickedActivityImage == null) {
                      Utils.showSnackBar(context: context, message: 'Please select an activity image..!!');
                      return;
                    }

                    if (formKey.currentState!.validate()) {

                      Utils.showLoadingBox(context: context, title: 'Saving Activity Details..');

                      String imageUrl = widget.activity.image;

                      String imageId = DateTime.now().millisecondsSinceEpoch.toString();

                      if (provider.pickedActivityImage != null) {
                        String? url = await provider.uploadImage(
                            file: provider.pickedActivityImage!,
                            path: 'crop_stage_activities/${widget.cropId}/${widget.stageId}/${widget.activity.id}/${widget.activity.name}_$imageId'
                        );
                        if (url != null) {
                          imageUrl = url;
                        } else {
                          Utils.showSnackBar(context: context, message: 'Error Uploading Activity Image..!!');
                        }
                      }

                      List<String> instructions = provider.activityInstructionsController.map((controller) => controller.text.trim()).toList();

                      Activity activity = Activity(
                        id: widget.activity.id,
                        name: widget.activity.name,
                        image: imageUrl,
                        summary: provider.activitySummaryController.text.trim(),
                        description: provider.activityDescriptionController.text.trim(),
                        instructions: instructions,
                        timestamp: DateTime.now(),
                      );

                      bool isSaved = await provider.saveActivityDetails(
                        cropId: widget.cropId,
                        stageId: widget.stageId,
                        activity: activity,
                      );

                      Navigator.pop(context);

                      if (isSaved) {
                        Utils.showSnackBar(context: context, message: 'Activity Details Saved Successfully..!!');
                      } else {
                        Utils.showSnackBar(context: context, message: 'Error Saving Activity Details..!!');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  )
                ),

                const SizedBox(width: 15),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Activity Image
                    Center(
                      child: InkWell(
                        onTap: () async {
                          Uint8List? image = await provider.pickImage();
                          if (image != null) {
                            provider.setPickedActivityImage(image);
                          }
                        },
                        child: Stack(
                          children: [
                            provider.pickedActivityImage != null
                                ?
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                provider.pickedActivityImage!,
                                width:  size.width * 0.4,
                                height: size.height * 0.4,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stace) {
                                  return Container(
                                    width:  size.width * 0.4,
                                    height: size.height * 0.4,
                                    color: Colors.grey.shade300,
                                  );
                                },
                              ),
                            )
                                :
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                provider.activityImageUrl,
                                width:  size.width * 0.4,
                                height: size.height * 0.4,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stace) {
                                  return Container(
                                    width:  size.width * 0.4,
                                    height: size.height * 0.4,
                                    color: Colors.grey.shade300,
                                  );
                                },
                              ),
                            ),

                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: ResponsiveBuilder.isDesktop(context)
                                    ? size.width * .04
                                    : size.width * .15,
                                height: ResponsiveBuilder.isDesktop(context)
                                    ? size.width * .02
                                    : size.width * .05,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.black.withOpacity(.8),
                                ),
                                child: const Center(
                                  child: Text("Edit"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Activity Summary
                    CustomTextField(
                      controller: provider.activitySummaryController,
                      labelText: 'Activity Summary',
                      maxLines: 2,
                    ),

                    const SizedBox(height: 25),

                    // Activity Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                      ),
                    ),

                    const SizedBox(height: 5),

                    CustomTextField(
                      controller: provider.activityDescriptionController,
                      labelText: 'Activity Description',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 20),

                    // Activity Instructions
                    Row(
                      children: [
                        const Text(
                          'Activity Instructions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),

                        const SizedBox(width: 5),

                        IconButton(
                          onPressed: provider.addActivityInstruction,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.orange,
                          )
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.activityInstructionsController.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                          title: CustomTextField(
                            controller: provider.activityInstructionsController[index],
                            hintText: 'Instruction ${index + 1}',
                            maxLines: 2,
                          ),

                          trailing: IconButton(
                            onPressed: () {
                              provider.removeActivityInstruction(index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )
                          ),
                        );
                      }
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
