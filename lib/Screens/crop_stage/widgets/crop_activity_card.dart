import 'package:flutter/material.dart';

import '../crop_activity_details_screen.dart';
import '../model/crop_stage_model.dart';

class CropActivityCard extends StatelessWidget {

  final Activity activity;
  final bool showDescription;

  const CropActivityCard({super.key, required this.activity, required this.showDescription});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CropActivityDetailsScreen(activity: activity)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                activity.image,
                height: MediaQuery.of(context).size.width * 0.1,
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
