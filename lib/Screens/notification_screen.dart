import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  bool buttonHovered = false;
  bool _isLoading = false;
  XFile? _imageFile;
  Uint8List? _imageBytes;

  TextEditingController titleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  Future<void> sendNotification(BuildContext context, String imageUrl) async {
    const String fcmUrl = "https://fcm.googleapis.com/fcm/send";
    const String serverKey =
        "AAAA94YwzBo:APA91bEkK_So83BZUKNm-H3q6MOdKyOzN6NoFviVt3NuBq0GLppV5O3sdtZNHjJC7HNoDM_W1tAlD-e-YnVEmEEqWpD681qOp_oL0lWXV27VuhHEqOl-Y6iwhzksQuldvkgadm4j2PZJ";

    Map<String, dynamic> notificationPayload = {
      "to": "/topics/Topics",
      "notification": {
        "title": titleController.text,
        "body": DescriptionController.text,
        "image": imageUrl
      }
    };

    String payloadJson = jsonEncode(notificationPayload);

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey',
        },
        body: payloadJson,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send notification. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending notification. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendNotification() async {
    setState(() {
      _isLoading = true;
    });
    if (_imageBytes != null && _imageBytes!.isNotEmpty) {
      String? imageUrl =
          await uploadImageToFirebaseStorage(_imageBytes!, 'image1.jpg');
      if (imageUrl != null) {
        await sendNotification(context, imageUrl);
        setState(() {
          _isLoading = true;
        });
        _resetState();
      } else {
        print('Failed to upload image to Firebase Storage.');
        setState(() {
          _isLoading = true;
        });
      }
    } else {
      print('No image selected.');
      setState(() {
        _isLoading = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget buildImageContainer(double width, XFile? imageFile,
      Uint8List? imageBytes, Function() onTapChangeImage) {
    return Container(
      width: width * 0.3,
      height: width * 0.15,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(111, 88, 255, 1),
            spreadRadius: -3,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
        color: Theme.of(context).cardColor,
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageFile != null && imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
              ),
            ),
          if (imageFile != null && imageBytes != null)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.white,
                onPressed: onTapChangeImage,
              ),
            ),
          if (imageFile == null || imageBytes == null)
            InkWell(
              onTap: onTapChangeImage,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<String?> uploadImageToFirebaseStorage(
      Uint8List imageBytes, String imageName) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('Notification').child(imageName);
      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _imageFile = pickedImage;
        _imageBytes = imageBytes;
      });
    }
  }

  void _resetState() {
    titleController.clear();
    DescriptionController.clear();

    setState(() {
      _imageFile = null;
      _imageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return _isLoading
        ? Center(
            child: Lottie.asset(
              "assets/images/loading.json",
              height: 140,
            ),
          )
        : Row(
            children: [
              Expanded(
                  child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: buildImageContainer(
                        width, _imageFile, _imageBytes, pickImage),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write Your Notification Title*',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.01,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: titleController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              //prefixIcon: const Icon(EvaIcons.),
                              hintText: "Notification Title",
                              isDense: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            textInputAction: TextInputAction.search,
                            style: TextStyle(color: krishiFontColorPallets[1]),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write Your Notification Description*',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.01,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: DescriptionController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              //prefixIcon: const Icon(EvaIcons.),
                              hintText: "Notification Description",
                              isDense: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            textInputAction: TextInputAction.search,
                            style: TextStyle(color: krishiFontColorPallets[1]),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  ElevatedButton(
                    onPressed: _sendNotification,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          buttonHovered ? Colors.red : Colors.transparent,
                      elevation: 0,
                      side: BorderSide(
                        color: buttonHovered
                            ? Colors.red
                            : const Color.fromRGBO(111, 88, 255, 1),
                      ),
                    ),
                    child: Text(
                      "Send Now",
                      style: TextStyle(
                        color: buttonHovered
                            ? Colors.white
                            : const Color.fromRGBO(111, 88, 255, 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: krishiSpacing * 3,
                  ),
                ],
              )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.11, vertical: height * 0.05),
                  child: Container(
                    height: height * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(),
                      color: Color(
                        int.parse("FFC4C7C5", radix: 16),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NoficationCard(
                          title: titleController.text.isNotEmpty
                              ? titleController.text
                              : 'Write a Title',
                          subTitle: DescriptionController.text.isNotEmpty
                              ? DescriptionController.text
                              : 'Write a Subtitle',
                          selectedImage: _imageBytes,
                        ),
                        Container(
                          color: Colors.black12,
                          height: height * 0.05,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                EvaIcons.menu,
                                color: Colors.black38,
                              ),
                              Icon(
                                Icons.circle_outlined,
                                color: Colors.black38,
                              ),
                              Icon(
                                EvaIcons.arrowForward,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
  }
}

class NoficationCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? imagePath;
  final Uint8List? selectedImage;
  const NoficationCard({
    super.key,
    this.title,
    this.subTitle,
    this.imagePath,
    this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Center',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Colors.black12,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: const Image(
                  image: AssetImage('assets/images/appIcon.jpg'),
                  width: 30,
                ),
              ),
              const SizedBox(width: 10),
              const Text('krishi seva kendra',
                  style: TextStyle(color: Colors.black54)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black54)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ??
                          'Write a Title', // Display default message if title is null or empty
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    Text(
                      subTitle ?? 'Write a Subtitle',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Container(
                child: selectedImage != null
                    ? Image.memory(
                        selectedImage!,
                        width: 50,
                      )
                    : (imagePath != null
                        ? Image.asset(
                            imagePath!,
                            width: 50,
                          )
                        : const SizedBox()),
              )
            ],
          ),
          const SizedBox(height: 0.05),
          const Divider(
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
