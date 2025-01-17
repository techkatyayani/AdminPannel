import 'package:flutter/material.dart';

import '../crop_activity_details_screen.dart';
import '../model/crop_stage_model.dart';

class CropActivityCard extends StatelessWidget {

  final String cropId;
  final String stageId;
  final Activity activity;

  const CropActivityCard({
    super.key,
    required this.cropId,
    required this.stageId,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
            CropActivityDetailsScreen(
              cropId: cropId,
              stageId: stageId,
              activity: activity,
            )
          )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.yellow.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                activity.image,
                width: double.maxFinite,
                height: MediaQuery.of(context).size.width * 0.1,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stace) {
                  return Container(
                    height: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.grey,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Activity Name
                  Text(
                    activity.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    activity.summary,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 3),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
