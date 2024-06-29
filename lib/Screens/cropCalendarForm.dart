import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';

class CropCalendarForm extends StatefulWidget {
  final String cropId;
  final String cropName;
  const CropCalendarForm(
      {super.key, required this.cropId, required this.cropName});

  @override
  State<CropCalendarForm> createState() => _CropCalendarFormState();
}

class _CropCalendarFormState extends State<CropCalendarForm> {
  bool isLoading = false;
  List<Uint8List>? _selectedImageBytesList = [];
  final List<String> _imageUrls = [];
  double _uploadProgress = 0.0;
  int imageIndex = 1;
  int selectedImages = 0;

  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _selectedImageBytesList =
              result.files.map((file) => file.bytes!).toList();
          selectedImages = _selectedImageBytesList!.length;
        });
      }
    } catch (e) {
      log('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<void> _uploadImages() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (_selectedImageBytesList != null &&
          _selectedImageBytesList!.isNotEmpty) {
        for (var imageBytes in _selectedImageBytesList!) {
          final storageRef = FirebaseStorage.instance.ref();
          final folderRef = storageRef.child('cropcalender/${widget.cropName}');
          final imageRef =
              folderRef.child('${DateTime.now().millisecondsSinceEpoch}');
          await imageRef.putData(imageBytes).snapshotEvents.forEach((event) {
            setState(() {
              _uploadProgress =
                  (event.bytesTransferred / event.totalBytes) * 100;
            });
          });
          final imageUrl = await imageRef.getDownloadURL();
          setState(() {
            _imageUrls.add(imageUrl);
            if (imageIndex < selectedImages) imageIndex += 1;
          });
          log("imageUrl $imageUrl");
        }
        await _saveImageUrlsToFirestore();
      }
    } catch (e) {
      log('Error uploading images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveImageUrlsToFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final cropCalendarRef = firestore
          .collection('product')
          .doc(widget.cropId)
          .collection('CropCalendar');
      int? length;
      await cropCalendarRef.get().then((snapshot) {
        length = snapshot.docs.length;
        log('Length: $length');
      });
      int firebaseId = length! + 1;
      for (var imageUrl in _imageUrls) {
        await cropCalendarRef
            .add({'ImageUrl': imageUrl, 'Id': firebaseId.toString()});
        firebaseId++;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crop Calendar Images Added')),
      );
      Navigator.pop(context);
    } catch (e) {
      log('Error saving image URLs to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image URLs to Firestore: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Crop Calendar"),
      ),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: size.height,
            width: size.width * .5,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(38, 40, 55, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "+ Add Images",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  selectedImages == 0
                      ? Container()
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Images Selected - $selectedImages',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                  const SizedBox(height: 20),
                  KrishiCalendarImagePicker(
                    onTap: _pickImages,
                    selectedImageBytesList: _selectedImageBytesList,
                  ),
                  const SizedBox(height: 20),
                  selectedImages == 0
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            if (_selectedImageBytesList != null &&
                                _selectedImageBytesList!.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageReorderScreen(
                                    imageBytesList: _selectedImageBytesList!,
                                    onReorderDone: (reorderedImages) {
                                      setState(() {
                                        _selectedImageBytesList =
                                            reorderedImages;
                                      });
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Rearrange Images",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  SizedBox(height: size.height * .02),
                  isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 20),
                            Column(
                              children: [
                                CircularProgressIndicator(
                                  value: _uploadProgress / 100,
                                  backgroundColor: Colors.grey,
                                  valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF00C853)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Uploading Image $imageIndex / $selectedImages",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${_uploadProgress.toStringAsFixed(2)}%',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: _uploadImages,
                          child: const Text(
                            "Upload Images",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KrishiCalendarImagePicker extends StatelessWidget {
  final VoidCallback onTap;
  final List<Uint8List>? selectedImageBytesList;

  const KrishiCalendarImagePicker(
      {super.key, required this.onTap, required this.selectedImageBytesList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size.width * .2,
            width: size.width * .15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: selectedImageBytesList != null &&
                      selectedImageBytesList!.isNotEmpty
                  ? ListView.builder(
                      itemCount: selectedImageBytesList!.length,
                      itemBuilder: (context, index) {
                        return Image.memory(selectedImageBytesList![index]);
                      },
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload),
                        SizedBox(height: 8),
                        Text("Upload Images"),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageReorderScreen extends StatefulWidget {
  final List<Uint8List> imageBytesList;
  final Function(List<Uint8List>) onReorderDone;

  const ImageReorderScreen(
      {super.key, required this.imageBytesList, required this.onReorderDone});

  @override
  State<ImageReorderScreen> createState() => _ImageReorderScreenState();
}

class _ImageReorderScreenState extends State<ImageReorderScreen> {
  late List<Uint8List> _imageBytesList;

  @override
  void initState() {
    super.initState();
    _imageBytesList = widget.imageBytesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rearrange Images"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onReorderDone(_imageBytesList);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _imageBytesList.removeAt(oldIndex);
            _imageBytesList.insert(newIndex, item);
          });
        },
        children: [
          for (int index = 0; index < _imageBytesList.length; index++)
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .4,
              key: ValueKey(index),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Image.memory(_imageBytesList[index]),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
