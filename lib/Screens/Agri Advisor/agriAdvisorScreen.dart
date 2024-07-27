import 'package:adminpannal/Screens/Agri%20Advisor/agriAdvisorDetailScreen.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class AgriAdvisorScreen extends StatefulWidget {
  const AgriAdvisorScreen({super.key});

  @override
  State<AgriAdvisorScreen> createState() => _AgriAdvisorScreenState();
}

class _AgriAdvisorScreenState extends State<AgriAdvisorScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        const SizedBox(height: krishiSpacing),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * .06),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Agri Doctor')
                .doc('100ms')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Lottie.asset('assets/images/loading.json',
                        height: 140));
              } else if (snapshot.hasError) {
                return const Center(child: Text("An error occurred."));
              } else if (!snapshot.hasData || snapshot.data?.data() == null) {
                return const Center(child: Text("No data available."));
              }
              Map<String, dynamic>? AgriData = snapshot.data!.data();
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: const AgriAdvisorDetailScreen(),
                        type: PageTransitionType.fade),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: boxColor,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Agri Advisor Video Call",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            const Text(
                              "Meet Url : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Expanded(
                              child: Text(
                                AgriData!['meetUrl'],
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        Row(
                          children: [
                            const Text(
                              "Discounted Price : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                AgriData['discountPrice'].toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        Row(
                          children: [
                            const Text(
                              "Actual Price : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                AgriData['totalPrice'].toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        Row(
                          children: [
                            const Text(
                              "Start / End Time : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                "${AgriData['startTime']} - ${AgriData['endTime']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        Row(
                          children: [
                            const Text(
                              "Payment ( Paid / Free ) :  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                AgriData['isRazorpay'] ? "Paid" : "Free",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
