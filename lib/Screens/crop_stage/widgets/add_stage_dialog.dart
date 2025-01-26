
import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddStageDialog extends StatefulWidget {

  final String cropId;

  const AddStageDialog({
    super.key,
    required this.cropId,
  });

  @override
  State<AddStageDialog> createState() => _AddStageDialogState();
}

class _AddStageDialogState extends State<AddStageDialog> {

  final formKey = GlobalKey<FormState>();

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
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                                'Add Stage',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )
                            ),

                            const SizedBox(height: 25),

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
                                const CustomMediaUploadCard(
                                  mediaRatio: 'Small icon like image (25 x 25)',
                                )
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Stage Name Heading
                      const Text(
                        'Stage Name',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange
                        ),
                      ),

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
                      const Text(
                        'Stage Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange
                        ),
                      ),

                      // Stage Products
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.stageProductControllers.length + 1,
                        itemBuilder: (context, index) {

                          if (index == provider.stageProductControllers.length) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    provider.addProductController();
                                  },
                                  label: const Text(
                                    'Add Product Id',
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
                              controller: provider.stageProductControllers[index],
                              hintText: 'Product Id',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),

                            trailing: IconButton(
                                onPressed: () {
                                  provider.removeProductController(index);
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
                              if (provider.pickedStageIcon == null ) {
                                Utils.showSnackBar(context: context, message: 'Please select stage icon..!!');
                                return;
                              }

                              if (formKey.currentState!.validate()) {
                                Utils.showLoadingBox(context: context, title: 'Adding Crop Stage...');

                                String stageId = provider.stages.isEmpty ? 'Stage1' : 'Stage${provider.stages.length + 1}';

                                String imageId = DateTime.now().millisecondsSinceEpoch.toString();

                                String? url = await provider.uploadImage(
                                  file: provider.pickedStageIcon!,
                                  path: 'crop_stage_activities/${widget.cropId}/${stageId}_$imageId'
                                );

                                List<String> products = provider.stageProductControllers.map((controller) => controller.text.trim()).toList();

                                Stage stage = Stage(
                                  stageId: stageId,
                                  stageImage: '',
                                  stageIcon: url.toString(),
                                  from: int.tryParse(provider.fromController.text.trim()) ?? 0,
                                  to: int.tryParse(provider.toController.text.trim()) ?? 0,
                                  products: products,
                                  activities: [],
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
                                  Utils.showSnackBar(context: context, message: 'Crop Stage added Successfully :)');
                                } else {
                                  Utils.showSnackBar(context: context, message: 'Failed to add crop stage..!!');
                                }

                                await Future.delayed(const Duration(milliseconds: 500));
                                provider.clearAddStageDialog();
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

showAddStageDialog({
  required BuildContext context,
  required String cropId,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AddStageDialog(
        cropId: cropId,
      );
    }
  );
}
