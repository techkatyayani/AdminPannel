import 'package:adminpannal/Screens/Crops/crop_disease_section/controller/disease_controller.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemLanguageCard extends StatelessWidget {
  final String cropId;
  final String diseaseId;
  final String symptomId;
  final String symptomTitle;
  final String symptomLanguage;
  final List<dynamic> symptom;
  const SystemLanguageCard({
    super.key,
    required this.symptom,
    required this.symptomLanguage,
    required this.symptomTitle,
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
                  '$symptomLanguage Text',
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
                        return Dialog(
                          child: Container(
                            height: MediaQuery.of(context).size.width / 2,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              children: [
                                const Text('Update '),
                                const SizedBox(height: 30),
                                TextFormField(
                                  controller:
                                      provider.symptomDiscriptionController,
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
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    provider.updateSyptom(
                                      cropId: cropId,
                                      diseaseId: diseaseId,
                                      symptomName: symptomTitle,
                                      symptomNewValue: symptom,
                                    );
                                  },
                                  child: const Text(
                                    'Update',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = symptom[index];
                return textCard(data);
              },
            ),
          ],
        ),
      );
    });
  }

  Widget textCard(
    final String text,
  ) {
    return Consumer<DiseaseController>(builder: (context, provider, child) {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 102, 84, 143),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
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
                    onTap: () {
                      provider.deleteSymptom(
                        symptomNewValue: symptom,
                        symptomValue: text,
                        cropId: cropId,
                        diseaseId: diseaseId,
                        symptomId: symptomId,
                        symptomName: symptomTitle,
                      );
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
            ),
          ],
        ),
      );
    });
  }
}
