import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  XFile? _imageFile;
  bool buttonHovered = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage;
    });
  }

  Future<void> sendNotification(BuildContext context) async {
    final String fcmUrl = "https://fcm.googleapis.com/fcm/send";
    final String serverKey = "AAAA94YwzBo:APA91bEkK_So83BZUKNm-H3q6MOdKyOzN6NoFviVt3NuBq0GLppV5O3sdtZNHjJC7HNoDM_W1tAlD-e-YnVEmEEqWpD681qOp_oL0lWXV27VuhHEqOl-Y6iwhzksQuldvkgadm4j2PZJ"; // Replace with your server key

    Map<String, dynamic> notificationPayload = {
      "to": "/topics/Topics",
      "notification": {
        "title": titleController.text,
        "body":  DescriptionController.text,
         "subtitle": "Hurry, get your deal while it lasts!",
        "image":
        "https://firebasestorage.googleapis.com/v0/b/krishisevakendra-8430a.appspot.com/o/download%20(1).jpg?alt=media&token=defa9fee-4f1d-4550-9dc8-c0d2debf636d"
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
          SnackBar(
            content: Text('Notification sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send notification. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending notification. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      children: [
       Expanded(
           child:  Column(
         // mainAxisAlignment: MainAxisAlignment.start,
         // crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           SizedBox(
             height: height * 0.05,
           ),

           Container(
             padding: EdgeInsets.all(width * 0.02),
             width: width * 0.2,
             decoration: BoxDecoration(
                 color: Colors.white10,
                 border: Border.all(
                   style: BorderStyle.solid,
                   color: Colors.white,
                   width: 1,
                 ),
                 borderRadius: BorderRadius.circular(5)),
             child: Center(
                 child: Column(
                   children: [
                     Icon(Icons.upload),
                     Text(
                       'Upload Image',
                       style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: width * 0.01,
                       ),
                     )
                   ],
                 )),
           ),

           SizedBox(
             height: height * 0.05,
           ),


           Padding(
               padding: EdgeInsets.symmetric(horizontal: width * 0.05),
               child:  Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     child: Text(
                       'Write Your Notification Title*',
                       style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: width * 0.01,
                       ),
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
               )
           ),

           SizedBox(
             height: height * 0.05,
           ),


           Padding(
               padding: EdgeInsets.symmetric(horizontal: width * 0.05),
               child:  Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     child: Text(
                       'Write Your Notification Description*',
                       style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: width * 0.01,
                       ),
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
               )
           ),

           SizedBox(height: height * 0.05,),

           ElevatedButton(
             onPressed: () {
               sendNotification(context);
             },
             child: Text(
               "Send Now",
               style: TextStyle(
                 color: buttonHovered ? Colors.white : Color.fromRGBO(111, 88, 255, 1),
               ),
             ),
             style: ElevatedButton.styleFrom(
               foregroundColor: Colors.white, backgroundColor: buttonHovered ? Colors.red : Colors.transparent,
               elevation: 0,
               side: BorderSide(
                 color: buttonHovered ? Colors.red : Color.fromRGBO(111, 88, 255, 1),
               ),
             ),
           )
           // ElevatedButton.icon(
           //   onPressed: pickImage,
           //   icon: Icon(Icons.image),
           //   label: Text('Select Image'),
           // ),
           // SizedBox(height: 20),
           // if (_imageFile != null)
           // // Display the selected image using a cached network image
           //   Image.network(
           //     _imageFile!.path, // Temporary display using local path
           //     // Replace with actual Firebase download URL after upload
           //   ),
           // SizedBox(height: 20),
           // if (_imageFile != null)
           //   ElevatedButton(
           //     onPressed: () async { },
           //     child: Text('Upload to Firebase'),
           //   ),
         ],
       )),
        Expanded(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.11, vertical: height * 0.05),
          child: Container(
            height: height * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(),
                color: Color(int.parse("FFC4C7C5", radix: 16))
            ),
            child: NoficationCard(
              title: titleController.text.isNotEmpty ? titleController.text : 'Write a Title',
              subTitle: DescriptionController.text.isNotEmpty ? DescriptionController.text : 'Write a Subtitle',

            ),
          ),
        ))
      ],
    );
  }
}

class NoficationCard extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const NoficationCard({
    Key? key,
    this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Center',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.black12,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: AssetImage('assets/images/appIcon.jpg'),
                  width: 30,
                ),
              ),
              SizedBox(width: 10),
              Text('krishi seva kendra', style: TextStyle(color: Colors.black54)),
              Icon(Icons.keyboard_arrow_down, color: Colors.black54)
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Write a Title', // Display default message if title is null or empty
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      subTitle ?? 'Write a Subtitle', // Display default message if subTitle is null or empty
                      style: TextStyle(
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
                child: Image(image: AssetImage('assets/images/notification.jpg'), width: 50),
              )
            ],
          ),
          SizedBox(height: 0.05),
          Divider(
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}

