import 'package:adminpannal/Screens/Crops/crop_disease_section/controller/disease_controller.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemLanguageCard extends StatelessWidget {
  final String cropId;
  final String diseaseId;
  final String symptomId;
  final String symptomLanguage;
  final List<dynamic> symptom;

  const SystemLanguageCard({
    super.key,
    required this.symptom,
    required this.symptomLanguage,
    required this.cropId,
    required this.diseaseId,
    required this.symptomId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DiseaseController>(builder: (context, provider, child) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$symptomLanguage Symptoms',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),

                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {

                          GlobalKey<FormState> formKey = GlobalKey<FormState>();

                          return symptomDialog(
                              context: context,
                              formKey: formKey,
                              isEdit: false,
                              oldSymptomValue: provider.symptomDescriptionController.text
                          );
                        }
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 102, 84, 143),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ListView.builder(
              itemCount: symptom.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {

                final text = symptom[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 102, 84, 143),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 20),

                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {

                              GlobalKey<FormState> formKey = GlobalKey<FormState>();

                              provider.symptomDescriptionController.text = text;

                              return symptomDialog(
                                context: context,
                                formKey: formKey,
                                isEdit: true,
                                oldSymptomValue: provider.symptomDescriptionController.text
                              );
                            }
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      InkWell(
                        onTap: () async {
                          bool status = await provider.deleteSymptom(
                            symptomNewValue: symptom,
                            symptomValue: text,
                            cropId: cropId,
                            diseaseId: diseaseId,
                            symptomId: symptomId,
                            symptomName: '${symptomLanguage.toLowerCase()}Symptoms',
                          );

                          if (status) {
                            Utils.showSnackBar(context: context, message: 'Symptom Deleted Successfully :)');
                          } else {
                            Utils.showSnackBar(context: context, message: 'Failed to delete symptom..!!');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget symptomDialog({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required bool isEdit,
    required String oldSymptomValue,
  }) {

    String previousText = oldSymptomValue;

    return Form(
      key: formKey,
      child: Dialog(
        child: Consumer<DiseaseController>(
          builder: (BuildContext context, DiseaseController provider, Widget? child) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${isEdit ? 'Update' : 'Add'} Symptom',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    controller: provider.symptomDescriptionController,
                    validator: (string) {
                      if (provider.symptomDescriptionController.text.isEmpty) {
                        return 'Please enter Symptom..!!';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter $symptomLanguage Symptom',
                      hintStyle:
                      TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

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
                        onPressed: () {
                          Navigator.pop(context);
                          provider.symptomDescriptionController.clear();
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
                          backgroundColor: const Color.fromARGB(255, 102, 84, 143),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size(100, 45),
                        ),
                        onPressed: () async {

                          if (formKey.currentState!.validate()) {
                            Utils.showLoadingBox(context: context, title: isEdit ? 'Updating Symptom...' : 'Adding Symptom...');

                            bool status = false;

                            if (!isEdit) {
                              status = await provider.addSymptom(
                                cropId: cropId,
                                diseaseId: diseaseId,
                                symptomId: symptomId,
                                symptomName: '${symptomLanguage.toLowerCase()}Symptoms',
                                symptomNewValue: symptom,
                              );
                            }
                            else {
                              status = await provider.editSymptom(
                                cropId: cropId,
                                diseaseId: diseaseId,
                                symptomId: symptomId,
                                symptomName: '${symptomLanguage.toLowerCase()}Symptoms',
                                oldSymptomValue: previousText,
                                newSymptomValue: provider.symptomDescriptionController.text.trim(),
                              );
                            }

                            Navigator.pop(context);
                            Navigator.pop(context);

                            if (status) {
                              Utils.showSnackBar(context: context, message: 'Symptom ${isEdit ? 'Updated' : 'Added'} Successfully');
                            } else {
                              Utils.showSnackBar(context: context, message: 'Failed to ${isEdit ? 'update' : 'add'} Symptom..!!');
                            }
                          }

                        },
                        child: Text(
                          isEdit ? 'Update' : 'Add',
                          style: const TextStyle(
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
          },
        ),
      ),
    );
  }
}
