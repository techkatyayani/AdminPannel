import 'dart:developer';
import 'dart:typed_data';

import 'package:adminpannal/Utils/app_language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/crop_stage_model.dart';

class CropStageProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Map<String, String> languagesMap = {
    'Bengali': 'bn',
    'English': 'en',
    'Hindi': 'hi',
    'Kannada': 'kn',
    'Malayalam': 'ml',
    'Marathi': 'mr',
    'Odia': 'or',
    'Tamil': 'ta',
    'Telugu': 'tl',
  };

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

                  String id = data['id'] ?? '';
                  String actId = data['act_id'] ?? '';
                  String image = data['image'] ?? '';
                  DateTime timestamp = DateTime.parse(data['timestamp'] ?? '');

                  final name = Map<String, String>.from(data['name'] ?? {});
                  final summary = Map<String, String>.from(data['summary'] ?? {});
                  final description = Map<String, String>.from(data['description'] ?? {});
                  final instructions = (data['instructions'] as Map?)?.map<String, List<String>>((key, value) {
                    return MapEntry(
                      key.toString(),
                      List<String>.from(value ?? []),
                    );
                  }) ?? {};

                  Activity activity = Activity(
                    id: id,
                    actId: actId,
                    image: image,
                    name: name,
                    summary: summary,
                    description: description,
                    instructions: instructions,
                    timestamp: timestamp,
                  );

                  return activity;

                }).toList();

              Activities allActivities = Activities(
                duration: duration,
                activity: activities,
              );

              return allActivities;
            })
        );

        CollectionProductModel? product;

        final collectionRef = await stagesRef.doc(stageDoc.id).collection('Products').get();

        if (collectionRef.docs.isNotEmpty) {
          final collectionDoc = collectionRef.docs.first;
          if (collectionDoc.exists) {
            Map<String, dynamic> data = collectionDoc.data();
            product = CollectionProductModel.fromJson(data);
          }
        }

        return stageData.copyWith(activities: allActivities, product: product);
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

  TextEditingController stageNameBnController = TextEditingController();
  TextEditingController stageNameEnController = TextEditingController();
  TextEditingController stageNameHiController = TextEditingController();
  TextEditingController stageNameKnController = TextEditingController();
  TextEditingController stageNameMlController = TextEditingController();
  TextEditingController stageNameMrController = TextEditingController();
  TextEditingController stageNameOrController = TextEditingController();
  TextEditingController stageNameTaController = TextEditingController();
  TextEditingController stageNameTlController = TextEditingController();


  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  TextEditingController collectionIdController = TextEditingController();

  TextEditingController collectionNameBnController = TextEditingController();
  TextEditingController collectionNameEnController = TextEditingController();
  TextEditingController collectionNameHiController = TextEditingController();
  TextEditingController collectionNameKnController = TextEditingController();
  TextEditingController collectionNameMlController = TextEditingController();
  TextEditingController collectionNameMrController = TextEditingController();
  TextEditingController collectionNameOrController = TextEditingController();
  TextEditingController collectionNameTaController = TextEditingController();
  TextEditingController collectionNameTlController = TextEditingController();

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

  final Map<String, Uint8List?> _pickedStageBannerImage = {};
  Map<String, Uint8List?> get pickedStageBannerImage => _pickedStageBannerImage;
  void setPickedStageBannerImage(String key, Uint8List? image) {
    _pickedStageBannerImage[key] = image;
    notifyListeners();
  }

  Future<void> initStageDialog(Stage stage) async {
    stageNameBnController.text = stage.stageNameBn;
    stageNameEnController.text = stage.stageNameEn;
    stageNameHiController.text = stage.stageNameHi;
    stageNameKnController.text = stage.stageNameKn;
    stageNameMlController.text = stage.stageNameMl;
    stageNameMrController.text = stage.stageNameMr;
    stageNameOrController.text = stage.stageNameOr;
    stageNameTaController.text = stage.stageNameTa;
    stageNameTlController.text = stage.stageNameTl;

    fromController.text = stage.from.toString();
    toController.text = stage.to.toString();

    collectionIdController.text = stage.product?.collectionId ?? '';

    collectionNameBnController.text = stage.product?.collectionName['bn'] ?? '';
    collectionNameEnController.text = stage.product?.collectionName['en'] ?? '';
    collectionNameHiController.text = stage.product?.collectionName['hi'] ?? '';
    collectionNameKnController.text = stage.product?.collectionName['kn'] ?? '';
    collectionNameMlController.text = stage.product?.collectionName['ml'] ?? '';
    collectionNameMrController.text = stage.product?.collectionName['mr'] ?? '';
    collectionNameOrController.text = stage.product?.collectionName['or'] ?? '';
    collectionNameTaController.text = stage.product?.collectionName['ta'] ?? '';
    collectionNameTlController.text = stage.product?.collectionName['tl'] ?? '';

    AppLanguage.languageCodes.map((code) async {
      _pickedStageBannerImage[code] = null;
    }).toList();

    notifyListeners();
  }

  void clearAddStageDialog() {
    stageNameBnController.clear();
    stageNameEnController.clear();
    stageNameHiController.clear();
    stageNameKnController.clear();
    stageNameMlController.clear();
    stageNameMrController.clear();
    stageNameOrController.clear();
    stageNameTaController.clear();
    stageNameTlController.clear();

    fromController.clear();
    toController.clear();
    // stageProductControllers.clear();

    // stageProductControllers.add(TextEditingController());

    _pickedStageIcon = null;
    _pickedStageImage = null;

    notifyListeners();
  }

  bool _stageNameExpanded = true;
  bool get stageNameExpanded => _stageNameExpanded;
  void toggleStageNameExpanded() {
    _stageNameExpanded = !stageNameExpanded;
    notifyListeners();
  }

  bool _collectionNameExpanded = true;
  bool get collectionNameExpanded => _collectionNameExpanded;
  void toggleCollectionNameExpanded() {
    _collectionNameExpanded = !collectionNameExpanded;
    notifyListeners();
  }

  bool _stageBannerExpanded = true;
  bool get stageBannerExpanded => _stageBannerExpanded;
  void toggleStageBannerExpanded() {
    _stageBannerExpanded = !stageBannerExpanded;
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

      if (stage.product != null) {
        final collectionRef = await ref.collection('Products').get();
        if (collectionRef.docs.isEmpty) {
          await ref.collection('Products').doc().set(stage.product!.toJson());
        } else {
          final doc = collectionRef.docs.first;
          await ref.collection('Products').doc(doc.id).set(stage.product!.toJson());
        }
      }

      if (stage.product == null) {
        _stages.add(stage);
      } else {
        int index = _stages.indexWhere((s) => s.stageId == stageId);
        if (index != -1) {
          _stages[index] = stage;
        }
      }
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

  /// ADD ACTIVITY

  Future<void> initActivityDetails({Activity? activity}) async {
    _activityImageUrl = activity?.image ?? '';
    activityNameController = TextEditingController(text: activity?.name['en'] ?? '');
    activitySummaryController = TextEditingController(text: activity?.summary['en'] ?? '');
    activityDescriptionController = TextEditingController(text: activity?.description['en'] ?? '');
    if (activity != null) {
      for (var instruction in activity.instructions['en'] ?? []) {
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
          .doc();

      data['act_id'] = activityRef.id;

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

  Future<bool> updateActivityDetails({
    required String cropId,
    required String stageId,
    required Activity activity,
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
          .doc(activity.id)
          .collection('details')
          .doc(activity.actId);

      log('Updating Activity Details..');
      await ref.set(data);

      fetchCropStages(cropId: cropId);

      log('Activity updated successfully at ${ref.path} :)');

      return true;

    } catch (e, s) {
      log('Error saving activity details..!!\n$e\n$s');
      return false;
    }
  }

  Future<bool> deleteActivities({
    required String cropId,
    required String stageId,
    required String activityId,
  }) async {
    try {

      await firestore
        .collection('product')
        .doc(cropId)
        .collection('Stages')
        .doc(stageId)
        .collection('activities')
        .doc(activityId)
        .delete();

      return true;

    } catch (e, s) {
      log('Error Deleting Activities...!!\n$e\n$s');
      return false;
    }
  }

  Future<bool> deleteActivity({
    required String cropId,
    required String stageId,
    required String activityId,
    required String activityName,
  }) async {
    try {

      await firestore
          .collection('product')
          .doc(cropId)
          .collection('Stages')
          .doc(stageId)
          .collection('activities')
          .doc(activityId)
          .collection('details')
          .doc(activityName)
          .delete();

      return true;

    } catch (e, s) {
      log('Error Deleting Activity...!!\n$e\n$s');
      return false;
    }
  }

  /// EDIT ACTIVITY

  Map<String, TextEditingController> activityNameControllers = {};
  Map<String, TextEditingController> activitySummaryControllers = {};
  Map<String, TextEditingController> activityDescriptionControllers = {};
  Map<String, List<TextEditingController>> activityInstructionsControllers = {};

  void initializeControllers({required Activity activity}) {

    languagesMap.forEach((language, code) {
      activityNameControllers[language] = TextEditingController(text: activity.name[code] ?? '');
      activitySummaryControllers[language] = TextEditingController(text: activity.summary[code] ?? '');
      activityDescriptionControllers[language] = TextEditingController(text: activity.description[code] ?? '');
      activityInstructionsControllers[language] = activity.instructions[code]?.map((instruction) => TextEditingController(text: instruction)).toList() ?? [];
    });
  }

  void clearControllers() {
    activityNameControllers.clear();
    activitySummaryControllers.clear();
    activityDescriptionControllers.clear();
    activityInstructionsControllers.clear();
  }

  void addInstructionControllers() {

    languagesMap.forEach((language, code) {
      activityInstructionsControllers[language]!.add(TextEditingController());
    });

    notifyListeners();
  }

  void addInstructionController(String key) {
    activityInstructionsControllers[key]!.add(TextEditingController());
    notifyListeners();
  }

  void removeInstructionController(String key, int index) {
    activityInstructionsControllers[key]!.removeAt(index);
    notifyListeners();
  }
}