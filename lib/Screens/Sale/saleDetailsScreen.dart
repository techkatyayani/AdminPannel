import 'dart:typed_data';
import 'package:adminpannal/Screens/Crops/addCropsForm.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

class SaleDetailsScreen extends StatefulWidget {
  const SaleDetailsScreen({super.key});

  @override
  State<SaleDetailsScreen> createState() => _SaleDetailsScreenState();
}

class _SaleDetailsScreenState extends State<SaleDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _collectionIdController = TextEditingController();
  final _daysController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  bool _isOfferOpen = false;
  Uint8List? _topstripBannerBytes;
  Uint8List? _topstripBannerHiBytes;
  Uint8List? _productBGBytes;
  Uint8List? _bgImageBytes;

  String? _topstripBannerUrl;
  String? _topstripBannerHiUrl;
  String? _productBGUrl;
  String? _bgImageUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('DynamicSection')
          .doc('HomeSection')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        setState(() {
          _collectionIdController.text = data['CollectionId'];
          _daysController.text = data['Days'].toString();
          _hoursController.text = data['hours'].toString();
          _minutesController.text = data['minutes'].toString();
          _isOfferOpen = data['isOffer'];
          _topstripBannerUrl = data['TopstripBanner'];
          _topstripBannerHiUrl = data['TopstripBannerHi'];
          _productBGUrl = data['ProductBG'];
          _bgImageUrl = data['BgImage'];
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load data: $e');
    }
  }

  Future<void> _pickFile(String label) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final image = img.decodeImage(Uint8List.fromList(bytes));
      final jpegBytes = img.encodeJpg(image!);

      setState(() {
        switch (label) {
          case 'TopstripBanner':
            _topstripBannerBytes = Uint8List.fromList(jpegBytes);
            break;
          case 'TopstripBannerHi':
            _topstripBannerHiBytes = Uint8List.fromList(jpegBytes);
            break;
          case 'ProductBG':
            _productBGBytes = Uint8List.fromList(jpegBytes);
            break;
          case 'BgImage':
            _bgImageBytes = Uint8List.fromList(jpegBytes);
            break;
        }
      });
    }
  }

  Future<String> _uploadImage(Uint8List bytes, String imageName) async {
    final ref =
        FirebaseStorage.instance.ref().child('KSK Sale').child(imageName);
    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }

  Future<void> _submitData() async {
    setState(() {
      isLoading = true;
    });
    final updateData = <String, dynamic>{
      'CollectionId': _collectionIdController.text,
      'Days': int.parse(_daysController.text),
      'hours': int.parse(_hoursController.text),
      'minutes': int.parse(_minutesController.text),
      'isOffer': _isOfferOpen,
    };

    try {
      if (_topstripBannerBytes != null) {
        updateData['TopstripBanner'] =
            await _uploadImage(_topstripBannerBytes!, 'TopstripBanner.jpg');
      }
      if (_topstripBannerHiBytes != null) {
        updateData['TopstripBannerHi'] =
            await _uploadImage(_topstripBannerHiBytes!, 'TopstripBannerHi.jpg');
      }
      if (_productBGBytes != null) {
        updateData['ProductBG'] =
            await _uploadImage(_productBGBytes!, 'ProductBG.jpg');
      }
      if (_bgImageBytes != null) {
        updateData['BgImage'] =
            await _uploadImage(_bgImageBytes!, 'BgImage.jpg');
      }

      if (updateData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('DynamicSection')
            .doc('HomeSection')
            .update(updateData);
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully!')),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes to update!')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Error updating data: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('KSK SALE')),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * .05, vertical: size.height * .04),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * .05, vertical: size.height * .04),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "KSK SALE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                const SizedBox(height: krishiSpacing),

                // Collection ID Field
                const Text(
                  'Collection ID',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: krishiSpacing / 2),
                KrishiTextField(
                  controller: _collectionIdController,
                  hintText: 'Collection ID',
                  width: size.width * .3,
                ),
                const SizedBox(height: krishiSpacing),

                // Days Field
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Days',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        KrishiTextField(
                          controller: _daysController,
                          hintText: 'Days',
                          width: size.width * .1,
                        ),
                      ],
                    ),
                    const SizedBox(width: krishiSpacing),

                    // Hours Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hours',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        KrishiTextField(
                          controller: _hoursController,
                          hintText: 'Hours',
                          width: size.width * .1,
                        ),
                      ],
                    ),
                    const SizedBox(width: krishiSpacing),

                    // Minutes Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Minutes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        KrishiTextField(
                          controller: _minutesController,
                          hintText: 'Minutes',
                          width: size.width * .1,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: krishiSpacing * 2),

                // Offer Switch
                Row(
                  children: [
                    const Text(
                      'Offer (OPEN/CLOSE)',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: krishiSpacing),
                    Switch(
                      value: _isOfferOpen,
                      onChanged: (value) {
                        setState(() {
                          _isOfferOpen = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: krishiSpacing * 2),

                // Topstrip Banner Picker
                const Text(
                  'Top Strip Banner',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: () => _pickFile('TopstripBanner'),
                    child: Container(
                      height: size.height * .1,
                      width: size.width * .6,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _topstripBannerBytes != null
                          ? Image.memory(_topstripBannerBytes!,
                              fit: BoxFit.cover)
                          : (_topstripBannerUrl != null
                              ? Image.network(_topstripBannerUrl!,
                                  fit: BoxFit.cover)
                              : const Icon(Icons.add_a_photo, size: 50)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Topstrip Banner Hi Picker
                const Text(
                  'Top Strip Banner Hindi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: () => _pickFile('TopstripBannerHi'),
                    child: Container(
                      height: size.height * .1,
                      width: size.width * .6,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _topstripBannerHiBytes != null
                          ? Image.memory(_topstripBannerHiBytes!,
                              fit: BoxFit.cover)
                          : (_topstripBannerHiUrl != null
                              ? Image.network(_topstripBannerHiUrl!,
                                  fit: BoxFit.cover)
                              : const Icon(Icons.add_a_photo, size: 50)),
                    ),
                  ),
                ),
                SizedBox(height: size.height * .1),

                // Product BG Picker
                Row(
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Sale Background Image (1200x920)',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => _pickFile('BgImage'),
                          child: Container(
                            // height: size.height * .1,
                            width: size.width * .1,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _bgImageBytes != null
                                ? Image.memory(_bgImageBytes!,
                                    fit: BoxFit.cover)
                                : (_bgImageUrl != null
                                    ? Image.network(_bgImageUrl!,
                                        fit: BoxFit.cover)
                                    : const Icon(Icons.add_a_photo, size: 50)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: size.width * .1),
                    Column(
                      children: [
                        const Text(
                          'Product Background Image',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: GestureDetector(
                            onTap: () => _pickFile('ProductBG'),
                            child: Container(
                              width: size.width * .2,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: _productBGBytes != null
                                  ? Image.memory(_productBGBytes!,
                                      fit: BoxFit.cover)
                                  : (_productBGUrl != null
                                      ? Image.network(_productBGUrl!,
                                          fit: BoxFit.cover)
                                      : const Icon(Icons.add_a_photo,
                                          size: 50)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // BG Image Picker
                const SizedBox(height: 20),

                // Submit Button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(size.width * .25, size.height * .05)),
                    onPressed: _submitData,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Upload',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
