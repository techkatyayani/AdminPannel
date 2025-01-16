import 'package:adminpannal/Screens/crop_stage/model/crop_stage_model.dart';
import 'package:flutter/material.dart';

class CropActivityDetailsScreen extends StatelessWidget {

  final Activity activity;

  const CropActivityDetailsScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          activity.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 15),

            Center(
              child: Image.network(
                activity.image,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.15,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stace) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: Colors.grey.shade300,
                  );
                },
              ),
            ),

            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                activity.summary,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70
                ),
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Heading
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Activity Description
                  Text(
                    activity.description,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Instructions Heading
                  const Text(
                    'Activity Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Activity Instructions
                  Text(
                    activity.instructions,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
