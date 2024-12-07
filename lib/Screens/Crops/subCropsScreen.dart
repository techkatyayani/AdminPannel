import 'package:adminpannal/Screens/Crops/cropCalenderScreen.dart';
import 'package:adminpannal/Screens/Crops/edit_crop_details.dart';
import 'package:adminpannal/Screens/Crops/symptomScreen.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SubCropsScreen extends StatefulWidget {
  final String cropName;
  final String cropId;
  const SubCropsScreen({
    super.key,
    required this.cropName,
    required this.cropId,
  });

  @override
  State<SubCropsScreen> createState() => _SubCropsScreenState();
}

class _SubCropsScreenState extends State<SubCropsScreen> {

  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  late TextEditingController _idController;

  @override
  void initState() {
    print(widget.cropId);
    print(widget.cropName);
    super.initState();
    _nameController = TextEditingController();
    _imageUrlController = TextEditingController();
    _idController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _idController.dispose();
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
        .doc(widget.cropId)
        .collection('Disease')
        .doc(documentId)
        .update({
      'Image': imageUrl.isNotEmpty ? imageUrl : _imageUrlController.text,
      'Name': _nameController.text,
      'id': _idController.text
    });
  }

  Future<void> _showUpdateDialog(String documentId, String currentName, String currentImageUrl, String currentId) async {
    List<int>? bytes;

    _nameController.text = currentName;
    _imageUrlController.text = currentImageUrl;
    _idController.text = currentId;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AlertDialog(
                title: const Text('Update Disease'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        controller: _idController,
                        decoration: const InputDecoration(labelText: 'Id'),
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
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
                                      ),
                                      Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
              ),
            );
          },
        );
      },
    );
  }

  void _updateTopImage(String imageName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${widget.cropId}$imageName.jpg');
      Uint8List uint8List = result.files.single.bytes!;
      UploadTask uploadTask = ref.putData(uint8List);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.cropId)
          .update({
        imageName: imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.cropName),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('product')
                    .doc(widget.cropId)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .12
                                              : size.width * .2,
                                      width: double.infinity,
                                      child: Image.network(
                                        snapshot.data['image2'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "English Banner",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _updateTopImage('image2');
                                    },
                                    child: Container(
                                      width:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .1
                                              : size.width * .15,
                                      height:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .03
                                              : size.width * .06,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        color: Colors.black.withOpacity(.8),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: ResponsiveBuilder.isDesktop(context)
                                        ? size.width * .12
                                        : size.width * .2,
                                    width: double.infinity,
                                    child: Image.network(
                                      snapshot.data['hindiimage2'] ??
                                          imagePlaceholder,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Hindi Banner",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _updateTopImage('hindiimage2');
                                  },
                                  child: Container(
                                    width: ResponsiveBuilder.isDesktop(context)
                                        ? size.width * .1
                                        : size.width * .15,
                                    height: ResponsiveBuilder.isDesktop(context)
                                        ? size.width * .03
                                        : size.width * .06,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      color: Colors.black.withOpacity(.8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: krishiSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => EditCropDetails(cropId: widget.cropId)));
                    },
                    child: const Text(
                      "Crop Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: CropCalanderScreen(
                              cropName: widget.cropName,
                              cropId: widget.cropId,
                              language: "English"),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    child: const Text(
                      "Crop Calendar English",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: CropCalanderScreen(
                              cropName: widget.cropName,
                              cropId: widget.cropId,
                              language: "Hindi"),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    child: const Text(
                      "Crop Calendar Hindi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('product')
                  .doc(widget.cropId)
                  .collection('Disease')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset(
                      'assets/images/loading.json',
                      height: 140,
                    ),
                  );
                } else {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ResponsiveBuilder.isDesktop(context) ? 6 : 2,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> diseaseData =
                          snapshot.data!.docs[index].data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: SymptomsScreen(
                                cropId: widget.cropId,
                                diseaseName: diseaseData['Name'],
                                diseaseId: snapshot.data.docs[index].id,
                              ),
                              type: PageTransitionType.topToBottom,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 3,
                                  offset: const Offset(2, 2),
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 3,
                                  offset: const Offset(-2, -2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .1
                                              : size.width * .25,
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                        child: Image(
                                          image: NetworkImage(
                                            diseaseData['Image'],
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: krishiSpacing),
                                    Text(
                                      diseaseData['Name'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showUpdateDialog(
                                        snapshot.data!.docs[index].id,
                                        snapshot.data!.docs[index]['Name'],
                                        snapshot.data!.docs[index]['Image'],
                                        snapshot.data!.docs[index]['id'],
                                      );
                                    },
                                    child: Container(
                                      width:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .04
                                              : size.width * .15,
                                      height:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .02
                                              : size.width * .05,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        color: Colors.black.withOpacity(.8),
                                      ),
                                      child: const Center(
                                        child: Text("Edit"),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
