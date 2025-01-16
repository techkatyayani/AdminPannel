import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            )
          ),

          const SizedBox(width: 15),
        ],
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 45,
                      color: Colors.white70,
                    )
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'No Stages Found..!!\nTap to Add Stage',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: provider.stages.length,
            itemBuilder: (context, index) {

              Stage stage = provider.stages[index];

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

                        GestureDetector(
                          onTap: () {

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
                                onTap: () {},
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.1 + 110,
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
                                      onTap: () {},
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      height: MediaQuery.of(context).size.width * 0.1,
                                    );
                                  }

                                  return CropActivityCard(
                                    activity: activities.activity[activityIndex],
                                    showDescription: false,
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
    );
  }

  Widget customAddIcon({
    required VoidCallback onTap,
    required double width,
    required double height,
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
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: MediaQuery.of(context).size.width * 0.025,
            ),
          ),
        ),
      ),
    );
  }
}
