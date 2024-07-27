import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AgriAdvisorDetailScreen extends StatefulWidget {
  const AgriAdvisorDetailScreen({super.key});

  @override
  State<AgriAdvisorDetailScreen> createState() =>
      _AgriAdvisorDetailScreenState();
}

class _AgriAdvisorDetailScreenState extends State<AgriAdvisorDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _meetUrlController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _discountedFeesController = TextEditingController();
  final _actualFeesController = TextEditingController();
  bool isLive = false;
  bool isPaid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAgriData();
  }

  void fetchAgriData() async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('Agri Doctor')
          .doc('100ms')
          .get();

      if (response.exists) {
        final document = response.data();
        if (document != null) {
          setState(() {
            _meetUrlController.text = document['meetUrl'];
            _startTimeController.text = document['startTime'];
            _endTimeController.text = document['endTime'];
            _discountedFeesController.text =
                document['discountPrice'].toString();
            _actualFeesController.text = document['totalPrice'].toString();
            isPaid = document['isRazorpay'];
            isLive = document['isAvailable'];
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agri Advisor Video Call"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(size.width * .04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: boxColor,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Agri Advisor Video Call",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    const SizedBox(height: krishiSpacing * 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Meet Url : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: krishiSpacing / 3),
                        TextFormField(
                          controller: _meetUrlController,
                          decoration: const InputDecoration(
                            hintText: "Meet Url",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the meet URL';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Discounted Price : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: krishiSpacing / 3),
                                  TextFormField(
                                    controller: _discountedFeesController,
                                    decoration: const InputDecoration(
                                      hintText: "Discounted Price",
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter discounted price';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: krishiSpacing),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Actual Price : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: krishiSpacing / 3),
                                  TextFormField(
                                    controller: _actualFeesController,
                                    decoration: const InputDecoration(
                                      hintText: "Actual Price",
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter actual price';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Start Time : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: krishiSpacing / 3),
                                  TextFormField(
                                    controller: _startTimeController,
                                    decoration: const InputDecoration(
                                      hintText: "Start Time",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter start time';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: krishiSpacing),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "End Time : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: krishiSpacing / 3),
                                  TextFormField(
                                    controller: _endTimeController,
                                    decoration: const InputDecoration(
                                      hintText: "End Time",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter end time';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Paid/Free : "
                                    " ${isPaid ? "Paid" : "Free"}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: krishiSpacing / 2),
                                  Switch(
                                    value: isPaid,
                                    onChanged: (value) {
                                      setState(() {
                                        isPaid = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Active/InActive : "
                                    " ${isLive ? "Active" : "InActive"}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: krishiSpacing / 2),
                                  Switch(
                                    value: isLive,
                                    onChanged: (value) {
                                      setState(() {
                                        isLive = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing * 2),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(size.width * .25, size.height * .05)),
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Agri Doctor')
                                      .doc('100ms')
                                      .update({
                                    'meetUrl': _meetUrlController.text,
                                    'startTime': _startTimeController.text,
                                    'endTime': _endTimeController.text,
                                    'discountPrice': int.parse(
                                        _discountedFeesController.text),
                                    'totalPrice':
                                        int.parse(_actualFeesController.text),
                                    'isRazorpay': isPaid,
                                    'isAvailable': isLive,
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Agri Advisor Data Update Successfully"),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  print('Error updating data: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.toString(),
                                      ),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
