import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SoilAndWaterTestingDetailsScreen extends StatefulWidget {
  final String title;
  final String titleHindi;

  const SoilAndWaterTestingDetailsScreen(
      {super.key, required this.title, required this.titleHindi});

  @override
  State<SoilAndWaterTestingDetailsScreen> createState() =>
      _SoilAndWaterTestingDetailsScreenState();
}

class _SoilAndWaterTestingDetailsScreenState
    extends State<SoilAndWaterTestingDetailsScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sourceHeadingController =
      TextEditingController();
  final TextEditingController _sourceHeadingHindiController =
      TextEditingController();
  final TextEditingController _recentPurchasedController =
      TextEditingController();
  final TextEditingController _recentPurchasedHindiController =
      TextEditingController();
  final TextEditingController _head1Controller = TextEditingController();
  final TextEditingController _head1Line1Controller = TextEditingController();
  final TextEditingController _head1Line2Controller = TextEditingController();
  final TextEditingController _head1Line3Controller = TextEditingController();
  final TextEditingController _head2Controller = TextEditingController();
  final TextEditingController _head2Line1Controller = TextEditingController();
  final TextEditingController _head2Line2Controller = TextEditingController();
  final TextEditingController _head2Line3Controller = TextEditingController();
  final TextEditingController _head2Line4Controller = TextEditingController();
  final TextEditingController _head2Line5Controller = TextEditingController();
  final TextEditingController _head1HindiController = TextEditingController();
  final TextEditingController _head1Line1HindiController =
      TextEditingController();
  final TextEditingController _head1Line2HindiController =
      TextEditingController();
  final TextEditingController _head1Line3HindiController =
      TextEditingController();
  final TextEditingController _head2HindiController = TextEditingController();
  final TextEditingController _head2Line1HindiController =
      TextEditingController();
  final TextEditingController _head2Line2HindiController =
      TextEditingController();
  final TextEditingController _head2Line3HindiController =
      TextEditingController();
  final TextEditingController _head2Line4HindiController =
      TextEditingController();
  final TextEditingController _head2Line5HindiController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(widget.title, widget.titleHindi);
  }

  Future<void> fetchData(String docName, String docNameHindi) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('DynamicSection')
          .doc(docName)
          .get();
      final responseHindi = await FirebaseFirestore.instance
          .collection('DynamicSection')
          .doc(docNameHindi)
          .get();

      if (response.exists && responseHindi.exists) {
        final document = response.data();
        final documentHindi = responseHindi.data();
        if (document != null && documentHindi != null) {
          setState(() {
            // English Content
            _amountController.text = (document['amount'] ?? '').toString();
            _sourceHeadingController.text = document['heading'] ?? '';
            _recentPurchasedController.text = document['recentPurchased'] ?? '';
            _head1Controller.text = document['title1'] ?? '';
            _head1Line1Controller.text = document['body1'] ?? '';
            _head1Line2Controller.text = document['body2'] ?? '';
            _head1Line3Controller.text = document['body3'] ?? '';
            _head2Controller.text = document['title2'] ?? '';
            _head2Line1Controller.text = document['subbody1'] ?? '';
            _head2Line2Controller.text = document['subbody2'] ?? '';
            _head2Line3Controller.text = document['subbody3'] ?? '';
            _head2Line4Controller.text = document['subbody4'] ?? '';
            _head2Line5Controller.text = document['subbody5'] ?? '';
            // Hindi Content
            _sourceHeadingHindiController.text = documentHindi['heading'] ?? '';
            _recentPurchasedHindiController.text =
                documentHindi['recentPurchased'] ?? '';
            _head1HindiController.text = documentHindi['title1'] ?? '';
            _head1Line1HindiController.text = documentHindi['body1'] ?? '';
            _head1Line2HindiController.text = documentHindi['body2'] ?? '';
            _head1Line3HindiController.text = documentHindi['body3'] ?? '';
            _head2HindiController.text = documentHindi['title2'] ?? '';
            _head2Line1HindiController.text = documentHindi['subbody1'] ?? '';
            _head2Line2HindiController.text = documentHindi['subbody2'] ?? '';
            _head2Line3HindiController.text = documentHindi['subbody3'] ?? '';
            _head2Line4HindiController.text = documentHindi['subbody4'] ?? '';
            _head2Line5HindiController.text = documentHindi['subbody5'] ?? '';
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  Future<void> submitButton() async {
    if (_formKey.currentState?.validate() ?? false) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Update'),
            content: const Text('Are you sure you want to update the content?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        setState(() {
          isLoading = true;
        });

        try {
          await FirebaseFirestore.instance
              .collection('DynamicSection')
              .doc(widget.title)
              .update({
            'amount':
                int.tryParse(_amountController.text) ?? 0, // Convert to int
            'heading': _sourceHeadingController.text,
            'recentPurchased': _recentPurchasedController.text,
            'title1': _head1Controller.text,
            'body1': _head1Line1Controller.text,
            'body2': _head1Line2Controller.text,
            'body3': _head1Line3Controller.text,
            'title2': _head2Controller.text,
            'subbody1': _head2Line1Controller.text,
            'subbody2': _head2Line2Controller.text,
            'subbody3': _head2Line3Controller.text,
            'subbody4': _head2Line4Controller.text,
            'subbody5': _head2Line5Controller.text,
          });

          await FirebaseFirestore.instance
              .collection('DynamicSection')
              .doc(widget.titleHindi)
              .update({
            'amount':
                int.tryParse(_amountController.text) ?? 0, // Convert to int
            'heading': _sourceHeadingHindiController.text,
            'recentPurchased': _recentPurchasedHindiController.text,
            'title1': _head1HindiController.text,
            'body1': _head1Line1HindiController.text,
            'body2': _head1Line2HindiController.text,
            'body3': _head1Line3HindiController.text,
            'title2': _head2HindiController.text,
            'subbody1': _head2Line1HindiController.text,
            'subbody2': _head2Line2HindiController.text,
            'subbody3': _head2Line3HindiController.text,
            'subbody4': _head2Line4HindiController.text,
            'subbody5': _head2Line5HindiController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Content updated successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update content: $e')),
          );
        } finally {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void dispose() {
    _head1Controller.dispose();
    _head1Line1Controller.dispose();
    _head1Line2Controller.dispose();
    _head1Line3Controller.dispose();
    _head2Controller.dispose();
    _head2Line1Controller.dispose();
    _head2Line2Controller.dispose();
    _head2Line3Controller.dispose();
    _head2Line4Controller.dispose();
    _head2Line5Controller.dispose();
    _head1HindiController.dispose();
    _head1Line1HindiController.dispose();
    _head1Line2HindiController.dispose();
    _head1Line3HindiController.dispose();
    _head2HindiController.dispose();
    _head2Line1HindiController.dispose();
    _head2Line2HindiController.dispose();
    _head2Line3HindiController.dispose();
    _head2Line4HindiController.dispose();
    _head2Line5HindiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Center(
          child: _head1Controller.text.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/images/loading.json",
                      height: 140,
                    ),
                    const Text(
                      "Please Wait",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: boxColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: krishiSpacing),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Soil Testing English",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26),
                                      ),
                                    ),
                                    const SizedBox(height: krishiSpacing * 2),
                                    _buildTextFormField(
                                        "Source Heading:",
                                        "Source Heading",
                                        _sourceHeadingController),
                                    _buildTextFormField("Amount :", "Amount",
                                        _amountController),
                                    _buildTextFormField(
                                        "Recent Purchased :",
                                        "Recent Purchased",
                                        _recentPurchasedController),
                                    const Divider(),
                                    const SizedBox(height: krishiSpacing),
                                    _buildTextFormField("Heading 1:",
                                        "Heading 1", _head1Controller),
                                    _buildTextFormField("Line 1:", "Line 1",
                                        _head1Line1Controller),
                                    _buildTextFormField("Line 2:", "Line 2",
                                        _head1Line2Controller),
                                    _buildTextFormField("Line 3:", "Line 3",
                                        _head1Line3Controller),
                                    const Divider(),
                                    _buildTextFormField("Heading 2:",
                                        "Heading 2", _head2Controller),
                                    _buildTextFormField("Line 1:", "Line 1",
                                        _head2Line1Controller),
                                    _buildTextFormField("Line 2:", "Line 2",
                                        _head2Line2Controller),
                                    _buildTextFormField("Line 3:", "Line 3",
                                        _head2Line3Controller),
                                    _buildTextFormField("Line 4:", "Line 4",
                                        _head2Line4Controller),
                                    _buildTextFormField("Line 5:", "Line 5",
                                        _head2Line5Controller),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: boxColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: krishiSpacing),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Soil Testing Hindi",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26),
                                      ),
                                    ),
                                    const SizedBox(height: krishiSpacing * 2),
                                    _buildTextFormField(
                                        "Source Heading:",
                                        "Source Heading",
                                        _sourceHeadingHindiController),
                                    _buildTextFormField("Amount :", "Amount",
                                        _amountController),
                                    _buildTextFormField(
                                        "Recent Purchased :",
                                        "Recent Purchased",
                                        _recentPurchasedHindiController),
                                    const Divider(),
                                    const SizedBox(height: krishiSpacing),
                                    _buildTextFormField("Heading 1:",
                                        "Heading 1", _head1HindiController),
                                    _buildTextFormField("Line 1:", "Line 1",
                                        _head1Line1HindiController),
                                    _buildTextFormField("Line 2:", "Line 2",
                                        _head1Line2HindiController),
                                    _buildTextFormField("Line 3:", "Line 3",
                                        _head1Line3HindiController),
                                    const Divider(),
                                    _buildTextFormField("Heading 2:",
                                        "Heading 2", _head2HindiController),
                                    _buildTextFormField("Line 1:", "Line 1",
                                        _head2Line1HindiController),
                                    _buildTextFormField("Line 2:", "Line 2",
                                        _head2Line2HindiController),
                                    _buildTextFormField("Line 3:", "Line 3",
                                        _head2Line3HindiController),
                                    _buildTextFormField("Line 4:", "Line 4",
                                        _head2Line4HindiController),
                                    _buildTextFormField("Line 5:", "Line 5",
                                        _head2Line5HindiController),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing * 2),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(size.width * .3, size.height * .07),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: submitButton,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                        ),
                        const SizedBox(height: krishiSpacing * 4)
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: krishiSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: krishiSpacing / 3),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
