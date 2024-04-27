import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({Key? key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('product').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              'assets/images/loading.json',
              height: 140,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(
                top: krishiSpacing * 2,
                left: krishiSpacing,
                right: krishiSpacing,
                bottom: krishiSpacing),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveBuilder.isDesktop(context) ? 5 : 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                mainAxisExtent: ResponsiveBuilder.isDesktop(context)
                    ? size.width * .12
                    : size.width * .25,
              ),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data = snapshot.data!.docs[index].data();
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: ResponsiveBuilder.isDesktop(context)
                            ? size.width * .08
                            : size.width * .2,
                        child: Image.network(
                          data['Image'],
                        ),
                      ),
                      Text(
                        data['Name'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
