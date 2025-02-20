
import 'dart:developer';

import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:adminpannal/Utils/app_language.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddStageDialog extends StatefulWidget {

  final String cropId;
  final Stage? currentStage;

  const AddStageDialog({
    super.key,
    required this.cropId,
    this.currentStage,
  });

  @override
  State<AddStageDialog> createState() => _AddStageDialogState();
}

class _AddStageDialogState extends State<AddStageDialog> {

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.currentStage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CropStageProvider>().initStageDialog(widget.currentStage!);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Form(
      canPop: false,
      key: formKey,
      child: Dialog(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: Consumer<CropStageProvider>(
              builder: (context, CropStageProvider provider, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                            'Add Stage',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                        ),
                      ),

                      const SizedBox(height: 25),

                      _buildStageImagesData(provider, size),

                      const SizedBox(height: 25),

                      // Stage Name Heading
                      _buildStageNameData(provider),

                      const SizedBox(height: 10),

                      // Stage Duration Heading
                      const Text(
                        'Stage Duration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange
                        ),
                      ),

                      Row(
                        children: [
                          
                          // From
                          Flexible(
                            child: CustomTextField(
                              controller: provider.fromController,
                              labelText: 'From',
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
                          ),
                      
                          const SizedBox(width: 10),
                      
                          // To
                          Flexible(
                            child: CustomTextField(
                              controller: provider.toController,
                              labelText: 'To',
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Stage Products Heading
                      if (widget.currentStage != null)
                        _buildStageProductData(provider),

                      const SizedBox(height: 10),

                      // Stage Banners Heading
                      if (widget.currentStage != null)
                        _buildStageBannerData(provider),

                      const SizedBox(height: 20),

                      _buildActionRow(provider),

                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }

  Widget _buildStageImagesData(CropStageProvider provider, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Stage Icon',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange
              ),
            ),

            InkWell(
                onTap: () async {
                  Uint8List? image = await provider.pickImage();
                  if (image != null) {
                    provider.setPickedStageIcon(image);
                  }
                },
                child: provider.pickedStageIcon != null
                    ?
                ClipRRect(
                  child: Image.memory(
                    provider.pickedStageIcon!,
                    width: size.width * 0.25,
                    height: size.height * 0.25,
                    fit: BoxFit.fill,
                  ),
                )
                    :
                (widget.currentStage?.stageIcon.isNotEmpty ?? false)
                    ?
                ClipRRect(
                  child: Image.network(
                    widget.currentStage?.stageIcon ?? '',
                    width: size.width * 0.25,
                    height: size.height * 0.25,
                    fit: BoxFit.fill,
                  ),
                )
                    :
                const CustomMediaUploadCard(
                  mediaRatio: 'Small icon like image (25 x 25)',
                )
            ),
          ],
        ),

        if (widget.currentStage != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Stage Background Image',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                ),
              ),

              InkWell(
                  onTap: () async {
                    Uint8List? image = await provider.pickImage();
                    if (image != null) {
                      provider.setPickedStageImage(image);
                    }
                  },
                  child: provider.pickedStageImage != null
                      ?
                  ClipRRect(
                    child: Image.memory(
                      provider.pickedStageImage!,
                      width: size.width * 0.25,
                      height: size.height * 0.25,
                      fit: BoxFit.fill,
                    ),
                  )
                      :
                  (widget.currentStage!.product?.backgroundImageUrl.isNotEmpty ?? false)
                      ?
                  ClipRRect(
                    child: Image.network(
                      widget.currentStage!.product?.backgroundImageUrl ?? '',
                      width: size.width * 0.25,
                      height: size.height * 0.25,
                      fit: BoxFit.fill,
                    ),
                  )
                      :
                  const CustomMediaUploadCard(
                    mediaRatio: 'Background Image for Stage Products',
                  )
              ),
            ],
          )
      ],
    );
  }

  Widget _buildStageNameData(CropStageProvider provider) {
    return Column(
      children: [

        InkWell(
          onTap: provider.toggleStageNameExpanded,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stage Name',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                ),
              ),

              Icon(
                provider.stageNameExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                color: Colors.white,
              )
            ],
          ),
        ),

        const SizedBox(height: 10),

        if (provider.stageNameExpanded) ...[
          CustomTextField(
            controller: provider.stageNameBnController,
            labelText: 'Bengali Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameEnController,
            labelText: 'English Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameHiController,
            labelText: 'Hindi Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameKnController,
            labelText: 'Kannada Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameMlController,
            labelText: 'Malayalam Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameMrController,
            labelText: 'Marathi Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameOrController,
            labelText: 'Oriya Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameTaController,
            labelText: 'Tamil Stage Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.stageNameTlController,
            labelText: 'Telugu Stage Name',
          ),
        ]

      ],
    );
  }

  Widget _buildStageProductData(CropStageProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stage Products',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange
          ),
        ),

        CustomTextField(
          controller: provider.collectionIdController,
          labelText: 'Collection Id',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
        ),

        const SizedBox(height: 10),

        InkWell(
          onTap: provider.toggleCollectionNameExpanded,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Collection Name',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                ),
              ),

              Icon(
                provider.collectionNameExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                color: Colors.white,
              )
            ],
          ),
        ),

        const SizedBox(height: 10),

        if (provider.collectionNameExpanded) ...[

          CustomTextField(
            controller: provider.collectionNameBnController,
            labelText: 'Bengali Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameEnController,
            labelText: 'English Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameHiController,
            labelText: 'Hindi Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameKnController,
            labelText: 'Kannada Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameMlController,
            labelText: 'Malayalam Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameMrController,
            labelText: 'Marathi Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameOrController,
            labelText: 'Oriya Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameTaController,
            labelText: 'Tamil Collection Name',
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: provider.collectionNameTlController,
            labelText: 'Telugu Collection Name',
          ),
        ],
      ],
    );
  }

  Widget _buildStageBannerData(CropStageProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: provider.toggleStageBannerExpanded,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stage Banners',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                ),
              ),

              Icon(
                provider.stageBannerExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up_sharp,
                color: Colors.white,
              )
            ],
          ),
        ),

        const SizedBox(height: 10),

        if (provider.stageBannerExpanded)
          Column(
            children: provider.pickedStageBannerImage.entries.map((entry) {

              String key = entry.key;
              Uint8List? image = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () async {
                    final file = await provider.pickImage();
                    if (file != null) {
                      provider.setPickedStageBannerImage(key, file);
                    }
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.125,
                    width: double.maxFinite,
                    child: image == null
                        ?
                    Image.network(
                        widget.currentStage!.product?.bannerImageUrl[key] ?? '',
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Tap to add ${AppLanguage.languageCodeToName[key]} banner image',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                    )
                        :
                    Image.memory(
                        image,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Tap to add ${AppLanguage.languageCodeToName[key]} banner image',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              );

            }).toList(),
          )
      ],
    );
  }

  Widget _buildActionRow(CropStageProvider provider) {
    return Row(
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
            provider.clearAddStageDialog();
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
            try {
              if (provider.pickedStageIcon == null && widget.currentStage == null) {
                Utils.showSnackBar(context: context, message: 'Please select stage icon..!!');
                return;
              }

              if (widget.currentStage != null) {
                if (provider.pickedStageImage == null && (widget.currentStage!.product?.backgroundImageUrl.isEmpty ?? true)) {
                  Utils.showSnackBar(context: context, message: 'Please select stage background image..!!');
                  return;
                }
                // for (var image in provider.pickedStageBannerImage.entries) {
                //   if (image.value == null && (widget.currentStage!.product?.bannerImageUrl[image.key]?.isEmpty ?? true)) {
                //     Utils.showSnackBar(context: context, message: 'Please select ${image.key} stage banner image..!!');
                //     return;
                //   }
                // }
              }

              if (formKey.currentState!.validate()) {
                Utils.showLoadingBox(context: context, title: '${widget.currentStage == null ? 'Adding' : 'Updating'} Crop Stage...');

                String stageId = provider.stages.isEmpty ? 'Stage1' : 'Stage${provider.stages.length + 1}';

                String imageId = DateTime.now().millisecondsSinceEpoch.toString();

                String? stageIconUrl = widget.currentStage?.stageIcon ?? '';

                if (provider.pickedStageIcon != null) {
                  stageIconUrl = await provider.uploadImage(
                      file: provider.pickedStageIcon!,
                      path: 'crop_stage_activities/${widget.cropId}/${stageId}_$imageId'
                  );
                }

                CollectionProductModel? product;

                if (widget.currentStage != null) {

                  stageId = widget.currentStage!.stageId;

                  final Map<String, String> stageBannerImages = {};

                  await Future.wait(
                    provider.pickedStageBannerImage.entries.map((entry) async {
                      String key = entry.key;
                      Uint8List? image = entry.value;

                      if (image != null) {
                        String? bannerImage = await provider.uploadImage(
                          file: image,
                          path: 'crop_stage_product/banner/${widget.cropId}/${stageId}_${DateTime.now().millisecondsSinceEpoch}',
                        );
                        stageBannerImages[key] = bannerImage ?? '';
                      } else {
                        stageBannerImages[key] = widget.currentStage!.product?.bannerImageUrl[key] ?? '';
                      }
                    }),
                  );

                  String? stageBgImageUrl = widget.currentStage!.product?.backgroundImageUrl ?? '';

                  if (provider.pickedStageImage != null) {
                    stageBgImageUrl = await provider.uploadImage(
                      file: provider.pickedStageImage!,
                      path: 'crop_stage_product/background/${widget.cropId}/${stageId}_${DateTime.now().millisecondsSinceEpoch}',
                    );
                  }

                  product = CollectionProductModel(
                    collectionId: provider.collectionIdController.text.trim(),
                    collectionName: {
                      'bn': provider.collectionNameBnController.text.trim(),
                      'en': provider.collectionNameEnController.text.trim(),
                      'hi': provider.collectionNameHiController.text.trim(),
                      'kn': provider.collectionNameKnController.text.trim(),
                      'ml': provider.collectionNameMlController.text.trim(),
                      'mr': provider.collectionNameMrController.text.trim(),
                      'or': provider.collectionNameOrController.text.trim(),
                      'ta': provider.collectionNameTaController.text.trim(),
                      'tl': provider.collectionNameTlController.text.trim(),
                    },
                    bannerImageUrl: stageBannerImages,
                    backgroundImageUrl: stageBgImageUrl.toString(),
                  );
                }

                Stage stage = Stage(
                  stageId: stageId,
                  stageIcon: stageIconUrl.toString(),
                  from: int.tryParse(provider.fromController.text.trim()) ?? 0,
                  to: int.tryParse(provider.toController.text.trim()) ?? 0,
                  activities: [],
                  product: product,
                  stageNameBn: provider.stageNameBnController.text.trim(),
                  stageNameEn: provider.stageNameEnController.text.trim(),
                  stageNameHi: provider.stageNameHiController.text.trim(),
                  stageNameKn: provider.stageNameKnController.text.trim(),
                  stageNameMl: provider.stageNameMlController.text.trim(),
                  stageNameMr: provider.stageNameMrController.text.trim(),
                  stageNameOr: provider.stageNameOrController.text.trim(),
                  stageNameTa: provider.stageNameTaController.text.trim(),
                  stageNameTl: provider.stageNameTlController.text.trim(),
                );

                bool status = await provider.addCropStage(
                  cropId: widget.cropId,
                  stageId: stageId,
                  stage: stage,
                );

                Navigator.pop(context);
                Navigator.pop(context);

                if (status) {
                  Utils.showSnackBar(context: context, message: 'Crop Stage ${widget.currentStage == null ? 'added' : 'updated'} Successfully :)');
                } else {
                  Utils.showSnackBar(context: context, message: 'Failed to ${widget.currentStage == null ? 'add' : 'update'} crop stage..!!');
                }

                await Future.delayed(const Duration(milliseconds: 500));
                provider.clearAddStageDialog();
              }
            } catch (e, s) {
              log('Error adding/updating stage crop :- $e\n$s');
              Navigator.pop(context);
            }
          },
          child: Text(
            widget.currentStage == null ? 'Add' : 'Update',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

showAddStageDialog({
  required BuildContext context,
  required String cropId,
  Stage? currentStage,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AddStageDialog(
        cropId: cropId,
        currentStage: currentStage,
      );
    }
  );
}
