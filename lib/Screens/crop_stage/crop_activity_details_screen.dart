import 'dart:typed_data';

import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

      provider.initializeControllers(activity: widget.activity);

      await Future.delayed(const Duration(seconds: 3));

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
              title: Text(
                widget.activity.name['en'] ?? '',
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

                      Map<String, String> activityName = provider.activityNameControllers.map((key, value) {
                        return MapEntry(
                          provider.languagesMap[key]!,
                          value.text.trim(),
                        );
                      });

                      Map<String, String> activitySummary = provider.activitySummaryControllers.map((key, value) {
                        return MapEntry(
                          provider.languagesMap[key]!,
                          value.text.trim(),
                        );
                      });

                      Map<String, String> activityDescription = provider.activityDescriptionControllers.map((key, value) {
                        return MapEntry(
                          provider.languagesMap[key]!,
                          value.text.trim(),
                        );
                      });

                      Map<String, List<String>> instructions = provider.activityInstructionsControllers.map((key, value) {
                        return MapEntry(
                          provider.languagesMap[key]!,
                          value.isNotEmpty ? value.map((instruction) => instruction.text.trim()).toList() : [''],
                        );
                      });


                      Activity activity = Activity(
                        id: widget.activity.id,
                        actId: widget.activity.actId,
                        name: activityName,
                        image: imageUrl,
                        summary: activitySummary,
                        description: activityDescription,
                        instructions: instructions,
                        timestamp: widget.activity.timestamp,
                      );

                      bool isSaved = await provider.updateActivityDetails(
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                                width:  size.width * 0.3,
                                height: size.height * 0.3,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stace) {
                                  return Container(
                                    width:  size.width * 0.3,
                                    height: size.height * 0.3,
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
                                width:  size.width * 0.3,
                                height: size.height * 0.3,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stace) {
                                  return Container(
                                    width:  size.width * 0.3,
                                    height: size.height * 0.3,
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

                    // Activity Name Heading
                    const Text(
                      'Activity Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                      ),
                    ),

                    // Activity Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.activityNameControllers.entries.map((entry) {
                        return CustomTextField(
                          controller: entry.value,
                          labelText: entry.key,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 25),

                    // Activity Summary Heading
                    const Text(
                      'Activity Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                      ),
                    ),

                    // Activity Summary
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.activitySummaryControllers.entries.map((entry) {
                        return CustomTextField(
                          controller: entry.value,
                          labelText: entry.key,
                          maxLines: 2,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 25),

                    // Activity Description Heading
                    const Text(
                      'Activity Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Activity Description
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.activityDescriptionControllers.entries.map((entry) {
                        return CustomTextField(
                          controller: entry.value,
                          labelText: entry.key,
                          maxLines: 4,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 25),

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
                          onPressed: provider.addInstructionControllers,
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
                      itemCount: provider.activityInstructionsControllers.length,
                      itemBuilder: (context, index) {

                        final entries = provider.activityInstructionsControllers.entries.toList();

                        final entry = entries[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height * 0.1
                                ),
                                decoration: const BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: Colors.white,
                                      width: 1.5
                                    )
                                  )
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: entry.value.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: CustomTextField(
                                        controller: entry.value[index],
                                        labelText: 'Instruction ${index + 1}',
                                        maxLines: 3,
                                      ),

                                      trailing: IconButton(
                                        onPressed: () {
                                          provider.removeInstructionController(entry.key, index);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ),

                              Positioned(
                                top: -15,
                                left: 10,
                                child: TextButton.icon(
                                  onPressed: () {
                                    provider.addInstructionController(entry.key);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    foregroundColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  ),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.amber,
                                  ),
                                  iconAlignment: IconAlignment.end,
                                  label: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
