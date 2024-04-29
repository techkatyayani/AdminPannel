import 'package:adminpannal/Screens/addCropsForm.dart';
import 'package:adminpannal/Screens/subCropsScreen.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct(String documentId, List<int>? imageBytes) async {
    String imageUrl = '';

    Navigator.of(context).pop();

    if (imageBytes != null) {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('$documentId.jpg');
      Uint8List uint8List = Uint8List.fromList(imageBytes);
      UploadTask uploadTask = ref.putData(uint8List);
      TaskSnapshot snapshot = await uploadTask;
      await uploadTask.whenComplete(() async {
        imageUrl = await snapshot.ref.getDownloadURL();
        _imageUrlController.text = imageUrl;
      });
    }

    await FirebaseFirestore.instance
        .collection('product')
        .doc(documentId)
        .update({
      'Image': imageUrl.isNotEmpty ? imageUrl : _imageUrlController.text,
      'Name': _nameController.text,
    });
  }

  Future<void> _showUpdateDialog(
      String documentId, String currentName, String currentImageUrl) async {
    List<int>? bytes;

    _nameController.text = currentName;
    _imageUrlController.text = currentImageUrl;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Update Crop'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Crop Name'),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: false,
                        );

                        if (result != null) {
                          setState(() {
                            bytes = result.files.single.bytes;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: bytes == null
                            ? Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network(
                                      currentImageUrl,
                                    ), // Display the current image
                                    Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black.withOpacity(.4),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Tap to select image",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Image.memory(
                                Uint8List.fromList(bytes!),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Update'),
                  onPressed: () {
                    _updateProduct(
                      documentId,
                      bytes,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        const SizedBox(height: krishiSpacing),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const AddCropsForm(),
                    type: PageTransitionType.fade,
                  ),
                );
              },
              child: const Text(
                "Add Crops",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                    top: krishiSpacing,
                    left: krishiSpacing,
                    right: krishiSpacing,
                    bottom: krishiSpacing),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        ResponsiveBuilder.isDesktop(context) ? 5 : 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    mainAxisExtent: ResponsiveBuilder.isDesktop(context)
                        ? size.width * .12
                        : size.width * .25,
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data =
                        snapshot.data!.docs[index].data();
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: SubCropsScreen(
                                    cropName: data['Name'],
                                    cropId: snapshot.data!.docs[index].id,
                                  ),
                                  type: PageTransitionType.topToBottom),
                            );
                          },
                          child: Container(
                            width: double.infinity,
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
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              print(snapshot.data!.docs[index]['Name']);
                              _showUpdateDialog(
                                  snapshot.data!.docs[index].id,
                                  snapshot.data!.docs[index]['Name'],
                                  snapshot.data!.docs[index]['Image']);
                            },
                            child: Container(
                              width: ResponsiveBuilder.isDesktop(context)
                                  ? size.width * .04
                                  : size.width * .15,
                              height: ResponsiveBuilder.isDesktop(context)
                                  ? size.width * .02
                                  : size.width * .05,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(10),
                                ),
                                color: Colors.black.withOpacity(.5),
                              ),
                              child: const Center(
                                child: Text("Edit"),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
