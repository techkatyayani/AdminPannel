import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDiscountCoupon extends StatefulWidget {
  final String couponName;
  final String englishDesc;
  final String hindiDesc;

  const AddDiscountCoupon({
    super.key,
    this.couponName = '',
    this.englishDesc = '',
    this.hindiDesc = '',
  });

  @override
  State<AddDiscountCoupon> createState() => _AddDiscountCouponState();
}

class _AddDiscountCouponState extends State<AddDiscountCoupon> {
  TextEditingController couponController = TextEditingController();
  TextEditingController englishDescController = TextEditingController();
  TextEditingController hindiDescController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    couponController.text = widget.couponName;
    englishDescController.text = widget.englishDesc;
    hindiDescController.text = widget.hindiDesc;
  }

  void _addData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String couponName = couponController.text;
    String couponDescEnglish = englishDescController.text;
    String couponDescHindi = hindiDescController.text;

    if (couponName.isNotEmpty) {
      CollectionReference couponData =
          FirebaseFirestore.instance.collection('Discount Coupons');

      try {
        await couponData.doc(couponName).set({
          'name': couponName,
          'englishDesc': couponDescEnglish,
          'hindiDesc': couponDescHindi,
          'timestamp': DateTime.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data added successfully'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add data: $e'),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Coupon Name'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Discount Coupon'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: size.width * 0.4, // Adjust width as needed
          decoration: BoxDecoration(
            color: const Color.fromRGBO(38, 40, 55, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "+ Add Coupon",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: couponController,
                  decoration: const InputDecoration(
                    labelText: 'Coupon Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: englishDescController,
                  maxLines: null, // Allows the text field to grow
                  decoration: const InputDecoration(
                    labelText: 'English Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: hindiDescController,
                  maxLines: null, // Allows the text field to grow
                  decoration: const InputDecoration(
                    labelText: 'Hindi Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _addData(context);
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Add Coupon',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
