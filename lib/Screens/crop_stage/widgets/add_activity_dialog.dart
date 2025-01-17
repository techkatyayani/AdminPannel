import 'dart:developer';

import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddActivityDialog extends StatefulWidget {

  final String cropId;
  final String stageId;
  final String activityId;
  final bool showDurationField;

  const AddActivityDialog({
    super.key,
    required this.cropId,
    required this.stageId,
    required this.activityId,
    required this.showDurationField,
  });

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    log('Activity Id = ${widget.activityId}');

    return Form(
      canPop: false,
      key: formKey,
      child: Dialog(
        child: Container(
          width: size.width * 0.75,
          height: size.height * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: Consumer<CropStageProvider>(
            builder: (context, CropStageProvider provider, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Add Activity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      )
                    ),

                    const SizedBox(height: 25),

                    InkWell(
                      onTap: () async {
                        Uint8List? image = await provider.pickImage();
                        if (image != null) {
                          provider.setPickedActivityImage(image);
                        }
                      },
                      child: provider.pickedActivityImage != null
                          ?
                      ClipRRect(
                        child: Image.memory(
                          provider.pickedActivityImage!,
                          width: size.width * 0.25,
                          height: size.height * 0.25,
                          fit: BoxFit.fill,
                        ),
                      )
                          :
                      const CustomMediaUploadCard()
                    ),

                    const SizedBox(height: 25),

                    // Activity Name
                    CustomTextField(
                      controller: provider.activityNameController,
                      labelText: 'Activity Name',
                    ),

                    const SizedBox(height: 10),

                    // Activity Duration
                    if (widget.showDurationField) ...[
                      CustomTextField(
                        controller: provider.activityDurationController,
                        labelText: 'Activity Duration',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        suffix: const Text(
                          'in Days',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],

                    // Activity Summary
                    CustomTextField(
                      controller: provider.activitySummaryController,
                      labelText: 'Activity Summary',
                      maxLines: 2,
                    ),

                    const SizedBox(height: 10),

                    // Activity Description
                    CustomTextField(
                      controller: provider.activityDescriptionController,
                      labelText: 'Activity Description',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 10),

                    // Activity Instructions
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.activityInstructionsController.length + 1,
                      itemBuilder: (context, index) {

                        if (index == provider.activityInstructionsController.length) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    provider.addActivityInstruction();
                                  },
                                  label: const Text(
                                    'Add Activity Instruction',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.white70,
                                  )
                              ),
                            ],
                          );
                        }

                        return ListTile(

                          contentPadding: EdgeInsets.zero,

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

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: const Size(100, 45),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await Future.delayed(const Duration(milliseconds: 500));
                            provider.disposeActivityDetail(disposeDuration: widget.showDurationField);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: const Size(100, 45),
                          ),
                          onPressed: () async {
                            if (provider.pickedActivityImage == null ) {
                              Utils.showSnackBar(context: context, message: 'Please select activity image..!!');
                              return;
                            }

                            if (formKey.currentState!.validate()) {
                              Utils.showLoadingBox(context: context, title: 'Adding Activity Details...');

                              String activityName = provider.activityNameController.text.trim();

                              String activityId = widget.activityId;

                              String imageUrl = '';

                              String imageId = DateTime.now().millisecondsSinceEpoch.toString();

                              if (provider.pickedActivityImage != null) {
                                String? url = await provider.uploadImage(
                                    file: provider.pickedActivityImage!,
                                    path: 'crop_stage_activities/${widget.cropId}/${widget.stageId}/$activityId/${activityName}_$imageId'
                                );
                                if (url != null) {
                                  imageUrl = url;
                                } else {
                                  Utils.showSnackBar(context: context, message: 'Error Adding Activity Image..!!');
                                }
                              }

                              List<String> instructions = provider.activityInstructionsController.map((controller) => controller.text.trim()).toList();

                              Activity activity = Activity(
                                id: activityId,
                                name: activityName,
                                image: imageUrl,
                                summary: provider.activitySummaryController.text.trim(),
                                description: provider.activityDescriptionController.text.trim(),
                                instructions: instructions,
                                timestamp: DateTime.now(),
                              );

                              bool status = await provider.saveActivityDetails(
                                cropId: widget.cropId,
                                stageId: widget.stageId,
                                activity: activity,
                                activityDuration: widget.showDurationField ? provider.activityDurationController.text.trim() : null,
                              );

                              Navigator.pop(context);
                              Navigator.pop(context);

                              if (status) {
                                Utils.showSnackBar(context: context, message: 'Activity added Successfully :)');
                              } else {
                                Utils.showSnackBar(context: context, message: 'Failed to crop add activity..!!');
                              }

                              await Future.delayed(const Duration(milliseconds: 500));
                              provider.disposeActivityDetail(disposeDuration: widget.showDurationField);

                            }
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}

showAddActivityDialog({
  required BuildContext context,
  required String cropId,
  required String stageId,
  required String activityId,
  required bool showDurationField,
}) async {

  await Provider.of<CropStageProvider>(context, listen: false).initActivityDetails();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AddActivityDialog(
        cropId: cropId,
        stageId: stageId,
        activityId: activityId,
        showDurationField: showDurationField,
      );
    }
  );
}
