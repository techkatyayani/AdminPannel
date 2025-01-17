import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/crop_stage_model.dart';

class CropStageProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  bool _isFetchingStages = false;
  bool get isFetchingStages => _isFetchingStages;
  void setFetchingStages(bool value) {
    _isFetchingStages = value;
    notifyListeners();
  }

  List<Stage> _stages = [];
  List<Stage> get stages => _stages;

  Future<void> fetchCropStages({required String cropId}) async {
    try {

      setFetchingStages(true);

      log('Fetching Crop Cycle...');

      final stagesRef = firestore
          .collection('product')
          .doc(cropId)
          .collection('Stages');

      final stageSnapshots = await stagesRef.get();

      List<dynamic> rawStages = await Future.wait(stageSnapshots.docs.map((stageDoc) async {

        if (!stageDoc.exists) return null;

        Stage stageData = Stage.fromJson(stageDoc.data());

        final activityCollection = stagesRef.doc(stageDoc.id).collection('activities');
        final activityDocs = await activityCollection.get();

        List<Activities> allActivities = await Future.wait(
            activityDocs.docs.map((activity) async {

              final detailsCollection = activityCollection.doc(activity.id).collection('details');
              final detailDocs = await detailsCollection.orderBy('timestamp').get();

              Map<String, dynamic> activityData = activity.data();

              int duration = activityData['duration'] ?? 0;

              List<Activity> activities = detailDocs.docs
                .where((doc) => doc.exists)
                .map((doc) {
                  Map<String, dynamic> data = doc.data();
                  data['id'] = activity.id;
                  return Activity.fromJson(data);
                }).toList();

              Activities allActivities = Activities(
                duration: duration,
                activity: activities,
              );

              return allActivities;
            })
        );

        return stageData.copyWith(activities: allActivities);
      }));

      List<Stage> finalStages = rawStages
          .where((stage) => stage != null)
          .map((stage) => stage as Stage)
          .toList();

      _stages = finalStages;
      notifyListeners();

      log('Crop Cycle fetched :)');

    } catch (e, s) {
      log('Error fetching crop stages..!!\n$e\n$s');
    } finally {
      setFetchingStages(false);
    }
  }

  /// ADD STAGE

  TextEditingController stageNameController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  List<TextEditingController> stageProductControllers = [TextEditingController()];
  void addProductController() {
    stageProductControllers.add(TextEditingController());
    notifyListeners();
  }
  void removeProductController(int index) {
    stageProductControllers.removeAt(index);
    notifyListeners();
  }

  Uint8List? _pickedStageIcon;
  Uint8List? get pickedStageIcon => _pickedStageIcon;
  void setPickedStageIcon(Uint8List? image) {
    _pickedStageIcon = image;
    notifyListeners();
  }

  Uint8List? _pickedStageImage;
  Uint8List? get pickedStageImage => _pickedStageImage;
  void setPickedStageImage(Uint8List? image) {
    _pickedStageImage = image;
    notifyListeners();
  }

  void clearAddStageDialog() {
    stageNameController.clear();
    fromController.clear();
    toController.clear();
    stageProductControllers.clear();

    stageProductControllers.add(TextEditingController());

    _pickedStageIcon = null;
    _pickedStageImage = null;

    notifyListeners();
  }

  Future<bool> addCropStage({
    required String cropId,
    required String stageId,
    required Stage stage,
  }) async {
    try {

      log('Adding Stage...');

      final ref = firestore
          .collection('product')
          .doc(cropId)
          .collection('Stages')
          .doc(stageId);

      Map<String, dynamic> data = stage.toJson();

      log('Stage Data = $data');

      await ref.set(data);

      log('Crop Stage added :)');

      _stages.add(stage);
      notifyListeners();

      return true;

    } catch (e, s) {
      log('Error adding stage..!!\n$e\n$s');
      return false;
    }
  }

  Future<bool> updateStageImage({
    required String cropId,
    required String stageId,
    required String imageUrl,
  }) async {
    try {

      log('Updating Stage Image...');

      final ref = firestore
          .collection('product')
          .doc(cropId)
          .collection('Stages')
          .doc(stageId);

      ref.update({
        'stageIcon': imageUrl,
      });

      int index = stages.indexWhere((stage) => stage.stageId == stageId);

      if (index != -1) {
        _stages[index] = _stages[index].copyWith(stageIcon: imageUrl);
        log('Local stage image updated at $index:)');
        notifyListeners();
      }

      log('Image Stage updated :)');

      return true;

    } catch (e, s) {
      log('Error saving image url..!!\n$e\n$s');
      return false;
    }
  }

  /// EDIT ACTIVITY

  Future<void> initActivityDetails({Activity? activity}) async {
    _activityImageUrl = activity?.image ?? '';
    activityNameController = TextEditingController(text: activity?.name ?? '');
    activitySummaryController = TextEditingController(text: activity?.summary ?? '');
    activityDescriptionController = TextEditingController(text: activity?.description ?? '');
    if (activity != null) {
      for (var instruction in activity.instructions) {
        activityInstructionsController.add(TextEditingController(text: instruction));
      }
    } else {
      activityInstructionsController.add(TextEditingController());
      activityDurationController = TextEditingController();
    }

    notifyListeners();
  }

  late TextEditingController activityNameController;
  late TextEditingController activitySummaryController;
  late TextEditingController activityDescriptionController;
  List<TextEditingController> activityInstructionsController = [];
  late TextEditingController activityDurationController;

  void addActivityInstruction() {
    activityInstructionsController.add(TextEditingController());
    notifyListeners();
  }
  void removeActivityInstruction(int index) {
    activityInstructionsController.removeAt(index);
    notifyListeners();
  }

  String _activityImageUrl = '';
  String get activityImageUrl => _activityImageUrl;
  void setActivityImageUrl(String url) {
    _activityImageUrl = url;
    notifyListeners();
  }

  void disposeActivityDetail({required bool disposeDuration}) {
    _activityImageUrl = '';
    activityNameController.dispose();
    activitySummaryController.dispose();
    activityDescriptionController.dispose();
    for (var instruction in activityInstructionsController) {
      instruction.dispose();
    }
    activityInstructionsController.clear();
    _pickedActivityImage = null;
    if (disposeDuration) {
      activityDurationController.dispose();
    }
    notifyListeners();
  }

  Uint8List? _pickedActivityImage;
  Uint8List? get pickedActivityImage => _pickedActivityImage;
  void setPickedActivityImage(Uint8List? image) {
    _pickedActivityImage = image;
    notifyListeners();
  }

  Future<Uint8List?> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      Uint8List? image = result.files.single.bytes;
      return image;
    }

    return null;
  }

  Future<String?> uploadImage({
    required Uint8List file,
    required String path,
  }) async {
    try {

      log('Uploading Image at $path...');

      var ref = storage.ref().child(path);

      UploadTask task = ref.putData(file);

      TaskSnapshot snapshot = await task;

      String imageUrl = await snapshot.ref.getDownloadURL();

      log('Image Uploaded Successfully :)');

      return imageUrl;

    } catch (e, s) {
      log('Error uploading image..!!\n$e\n$s');
      return null;
    }
  }

  Future<bool> saveActivityDetails({
    required String cropId,
    required String stageId,
    required Activity activity,
    String? activityDuration,
  }) async {
    try {
      
      Map<String, dynamic> data = activity.toJson();
      log('Activity Data = $data');

      final ref = firestore
          .collection('product')
          .doc(cropId)
          .collection('Stages')
          .doc(stageId)
          .collection('activities')
          .doc(activity.id);

      if (activityDuration != null) {
        log('Saving Activity Duration...');
        await ref.set({
          'duration': int.parse(activityDuration.toString()),
        });
      }

      DocumentReference<Map<String, dynamic>> activityRef = ref
          .collection('details')
          .doc(activity.name);

      log('Saving Activity Details..');
      activityRef.set(data);

      fetchCropStages(cropId: cropId);

      log('Activity updated successfully at ${activityRef.path} :)');

      return true;

    } catch (e, s) {
      log('Error saving activity details..!!\n$e\n$s');
      return false;
    }
  }
}