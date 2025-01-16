import 'dart:developer';
import 'dart:io';

import 'package:adminpannal/Screens/Krishi%20News/model/krishi_news_model.dart';
import 'package:adminpannal/Screens/Krishi%20News/service/krishi_news_service.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class KrishiNewsProvider with ChangeNotifier {

  final KrishiNewsService service = KrishiNewsService();

  final ImagePicker _picker = ImagePicker();

  TextEditingController authorController = TextEditingController(text: 'Krishi Seva Kendra');
  TextEditingController titleController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController productController = TextEditingController();

  File? _postImage;
  File? get postImage => _postImage;

  Uint8List? _postImageBytes;
  Uint8List? get postImageBytes => _postImageBytes;

  File? _postVideo;
  File? get postVideo => _postVideo;

  Uint8List? _postVideoBytes;
  Uint8List? get postVideoBytes => _postVideoBytes;

  String? _selectedVideo;
  String? get selectedVideo => _selectedVideo;

  Future<void> pickFile({required bool isVideo}) async {
    if (kIsWeb) {
      log('${isVideo ? 'Web Video' : 'Web Image'} will be selected..');

      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = isVideo ? 'video/*' : 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final file = uploadInput.files?.first;
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) {
          if (isVideo) {
            _postVideoBytes = reader.result as Uint8List;

            _selectedVideo = file?.name ?? 'unknown';
            // final extension = path.extension(fileName);
            // _selectedVideo = fileName + extension;
            log('Selected video name: $_selectedVideo');
          } else {
            _postImageBytes = reader.result as Uint8List;
          }
          notifyListeners();
        });

        if (file != null) {
          reader.readAsArrayBuffer(file);
        }
      });
    }
    else {
      if (isVideo) {
        final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
        if (file != null) {
          _postVideo = File(file.path);
          _postVideoBytes = await file.readAsBytes();
          notifyListeners();
        }
      } else {
        final XFile? file = await _picker.pickImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.front,
        );
        if (file != null) {
          _postImage = File(file.path);
          _postImageBytes = await file.readAsBytes();
          notifyListeners();
        }
      }
    }
  }

  Future<void> createPost({
    required BuildContext context,
    required String mediaType,
  }) async {
    try {

      Utils.showLoadingBox(context: context, title: 'Posting $mediaType...');

      String author = authorController.text.trim();
      String title = titleController.text.trim();
      String caption = captionController.text.trim();
      String product = productController.text.trim();


      log('Author: $author');
      log('Title: $title');
      log('Caption: $caption');
      log('Caption: $product');
      log('Media Type $mediaType');

      dynamic mediaFile;

      if (mediaType == 'image') {
        mediaFile = postImage ?? postImageBytes;
      } else {
        mediaFile = postVideo ?? postVideoBytes;
      }

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final storagePath = mediaType == 'image'
          ? 'post_images/$fileName'
          : 'post_videos/$fileName';

      log('Storing $mediaType at $storagePath...');
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);

      log('Uploading media file to Firebase Storage...');
      final uploadTask = mediaFile is File
          ? await storageRef.putFile(mediaFile)
          : await storageRef.putData(mediaFile);

      log('Getting download URL for uploaded file...');
      final mediaUrl = await uploadTask.ref.getDownloadURL();
      log('Media URL: $mediaUrl');

      final newPostRef = FirebaseFirestore.instance.collection('KrishiNewsPosts').doc();
      final timestamp = DateTime.now();

      log('Creating Firestore document...');
      final data = {
        'id': newPostRef.id,
        'author': author,
        'caption': caption,
        'title': title,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'likedBy': [],
        'timestamp': Timestamp.fromDate(timestamp),
        'product': product,
      };

      await newPostRef.set(data);
      log('Firestore document created successfully.');

      clearPostDialog();

      Navigator.pop(context);
      Navigator.pop(context);
      Utils.showSnackBar(
        context: context,
        message: '${mediaType == 'image' ? 'Image' : 'Video'} posted successfully :)'
      );

    } catch (e) {
      log('Error posting $mediaType || $e');
    }
  }

  void clearPostDialog() {

    log('Every thing cleared..!!');

    // authorController.clear();
    titleController.clear();
    captionController.clear();
    productController.clear();

    _postImage = null;
    _postImageBytes = null;

    _postVideo = null;
    _postVideoBytes = null;

    notifyListeners();
  }

  Stream<List<KrishiNewsModel>> fetchPost(String mediaType) async* {
    List<KrishiNewsModel> krishiNews = await service.fetchPost(mediaType);
    yield krishiNews;
  }

  Future<bool> deletePost(String postId) async {
    return await service.deletePost(postId);
  }

}