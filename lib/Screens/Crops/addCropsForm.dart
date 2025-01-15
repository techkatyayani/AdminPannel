import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class AddCropsForm extends StatefulWidget {
  const AddCropsForm({super.key});

  @override
  State<AddCropsForm> createState() => _AddCropsFormState();
}

class _AddCropsFormState extends State<AddCropsForm> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _cropNameController;
  Uint8List? _selectedCropImageBytes;

  Uint8List? _selectedEnglishBannerImageBytes;
  Uint8List? _selectedHindiBannerImageBytes;

  final List<Uint8List?> _diseaseImages = [];
  final List<TextEditingController> _diseaseControllers = [];
  final List<TextEditingController> _collectionIdControllers = [];

  final List<List<TextEditingController>> _symptomControllersList = [];

  @override
  void initState() {
    super.initState();
    _cropNameController = TextEditingController();

    _diseaseControllers.add(TextEditingController());
    _collectionIdControllers.add(TextEditingController());
    _diseaseImages.add(null);

    _symptomControllersList.add([TextEditingController()]);
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    for (var controller in _diseaseControllers) {
      controller.dispose();
    }
    for (var list in _symptomControllersList) {
      for (var controller in list) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _selectedCropImageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _selectedEnglishBannerImageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _pickDiseaseImage(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _diseaseImages[index] = result.files.single.bytes;
      });
    }
  }

  void _addDisease() {
    setState(() {
      _diseaseControllers.add(TextEditingController());
      _collectionIdControllers.add(TextEditingController());
      _diseaseImages.add(null);
      _symptomControllersList.add([TextEditingController()]);
    });
  }

  void _deleteDisease(int index) {
    setState(() {
      _diseaseControllers.removeAt(index);
      _diseaseImages.removeAt(index);
      _symptomControllersList.removeAt(index);
    });
  }

  void _addSymptom(int diseaseIndex) {
    setState(() {
      _symptomControllersList[diseaseIndex].add(TextEditingController());
    });
  }

  void _deleteSymptom(int diseaseIndex, int symptomIndex) {
    setState(() {
      _symptomControllersList[diseaseIndex].removeAt(symptomIndex);
    });
  }

  void _submitForm() {
    if (_selectedCropImageBytes == null || _selectedEnglishBannerImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select crop image and banner image.'),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {

    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Add Crop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(38, 40, 55, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Crop Details",
                    style: TextStyle(fontSize: size.width * .014),
                  ),

                  const Divider(),

                  const SizedBox(height: 16),

                  KrishiTextField(
                    controller: _cropNameController,
                    width: size.width * 0.4,
                    hintText: 'Enter Crop Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter crop name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      KrishiImagePicker(
                        onTap: _pickImage,
                        selectedImageBytes: _selectedCropImageBytes,
                        title: 'Crop Image',
                      ),
                      const SizedBox(width: 20),
                      KrishiImagePicker(
                        onTap: _pickBannerImage,
                        selectedImageBytes: _selectedEnglishBannerImageBytes,
                        title: 'Crop Banner Image',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Diseases Details",
                    style: TextStyle(fontSize: size.width * .014),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _diseaseControllers.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Disease ${index + 1}",
                                  style: TextStyle(
                                    fontSize: size.width * .012,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                KrishiTextField(
                                  controller: _diseaseControllers[index],
                                  width: size.width * .4,
                                  hintText: 'Enter Disease ${index + 1} Name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter disease name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: krishiSpacing),
                                KrishiTextField(
                                  controller: _collectionIdControllers[index],
                                  width: size.width * .4,
                                  hintText: 'Enter Id ${index + 1}',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter disease name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    KrishiImagePicker(
                                      onTap: () => _pickDiseaseImage(index),
                                      selectedImageBytes: _diseaseImages[index],
                                      title: 'Disease Image',
                                    ),
                                    const SizedBox(width: 20),
                                    TextButton(
                                      onPressed: () => _deleteDisease(index),
                                      child: Text(
                                        "⛔ Remove Section",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.width * .01,
                                ),
                                const Divider(),
                                SizedBox(
                                  height: size.width * .01,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Symptoms",
                                  style: TextStyle(fontSize: size.width * .014),
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      _symptomControllersList[index].length,
                                  itemBuilder: (context, symptomIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: KrishiTextField(
                                              controller:
                                                  _symptomControllersList[index]
                                                      [symptomIndex],
                                              width: size.width * .4,
                                              hintText:
                                                  'Enter Symptom ${symptomIndex + 1}',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter symptom';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _deleteSymptom(
                                                index, symptomIndex),
                                            icon: Icon(
                                              Icons.delete_outline,
                                              size: size.width * .02,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => _addSymptom(index),
                                  child: Text(
                                    "Add Symptom",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: krishiSpacing),
                  SizedBox(
                    width: size.width * .1,
                    height: size.width * .03,
                    child: ElevatedButton(
                      onPressed: _addDisease,
                      child: Text(
                        "Add Disease",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size.width * .2,
                      height: size.width * .03,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Submit',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
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

class KrishiImagePicker extends StatelessWidget {
  final VoidCallback onTap;
  final Uint8List? selectedImageBytes;
  final String title;

  const KrishiImagePicker({
    super.key,
    required this.onTap,
    required this.selectedImageBytes,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: size.width * .012),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size.width * .1,
            width: size.width * .2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: selectedImageBytes != null
                  ? Image.memory(selectedImageBytes!)
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload),
                        SizedBox(height: 8),
                        Text("Upload Image"),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class KrishiTextField extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String hintText;
  final String? Function(String?)? validator;

  const KrishiTextField({
    super.key,
    required this.controller,
    required this.width,
    required this.hintText,
    this.validator,
  });

  @override
  State<KrishiTextField> createState() => _KrishiTextFieldState();
}

class _KrishiTextFieldState extends State<KrishiTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: krishiPrimaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
