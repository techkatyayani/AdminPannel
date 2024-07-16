import 'package:adminpannal/Screens/addDiscountcoupon.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class DiscountCoupons extends StatefulWidget {
  const DiscountCoupons({super.key});

  @override
  State<DiscountCoupons> createState() => _DiscountCouponsState();
}

class _DiscountCouponsState extends State<DiscountCoupons> {
  Future<void> deleteCoupon(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Discount Coupons")
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete coupon: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child: const AddDiscountCoupon(),
                      type: PageTransitionType.fade,
                    ));
              },
              child: const Text(
                "Add Coupon",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Discount Coupons")
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/images/loading.json',
                  height: 140,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No discount coupons available"));
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = documents[index];
                String documentId = document.id;
                String englishDesc = document['englishDesc'] ?? 'N/A';
                String hindiDesc = document['hindiDesc'] ?? 'N/A';
                String name = document['name'] ?? 'N/A';

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: krishiFontColorPallets[0],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.discount,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Coupon Delete'),
                                            content: Text(
                                                '$name \nAre you sure you want to delete this?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteCoupon(documentId);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: AddDiscountCoupon(
                                                  couponName: name,
                                                  englishDesc: englishDesc,
                                                  hindiDesc: hindiDesc,
                                                ),
                                                type: PageTransitionType.fade));
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'En Description: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      englishDesc,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    'Hi Description: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      hindiDesc,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
