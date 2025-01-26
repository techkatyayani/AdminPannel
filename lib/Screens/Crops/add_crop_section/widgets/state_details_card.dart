
import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StateDetailsCard extends StatelessWidget {

  final VoidCallback onBack;

  const StateDetailsCard({super.key, required this.onBack});

  final String message = "Pick the Indian states where this crop is cultivated.";

  @override
  Widget build(BuildContext context) {
    return Consumer<CropProvider>(
      builder: (BuildContext context, CropProvider provider, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select States',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 15),

            const Divider(),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  // childAspectRatio: 1,
                ),
                itemCount: provider.states.length,
                itemBuilder: (context, index) {

                  String state = provider.states[index];

                  return GestureDetector(
                    onTap: () {
                      if (provider.doesPickedStatesContain(state)) {
                        provider.removePickedState(state);
                      } else {
                        provider.addPickedState(state);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              state,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          Align(
                            alignment: Alignment.topRight,
                            child: Checkbox(
                              value: provider.doesPickedStatesContain(state),
                              onChanged: (value) {
                                if (provider.doesPickedStatesContain(state)) {
                                  provider.removePickedState(state);
                                } else {
                                  provider.addPickedState(state);
                                }
                              },
                              checkColor: Colors.white,
                              fillColor: const WidgetStatePropertyAll<Color>(Colors.black),
                              activeColor: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: onBack,
                  label: const Text(
                    'Back',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                  ),
                  iconAlignment: IconAlignment.start,
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                  ),
                ),

                Flexible(
                  child: Text(
                    // 'Please add Disease Details. You can add disease details only, try to add respective disease symptoms after completing the crop creation process.',
                    message,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                TextButton(
                  onPressed: () async {

                    Utils.showLoadingBox(context: context, title: 'Saving Crop Details...');

                    bool status = await provider.addNewCrop();

                    Navigator.pop(context);

                    if (status) {
                      Utils.showSnackBar(context: context, message: 'New Crop Added Successfully :)');
                      Navigator.pop(context);
                    } else {
                      Utils.showSnackBar(context: context, message: 'Failed to Add New Crop..!!');
                    }

                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}
