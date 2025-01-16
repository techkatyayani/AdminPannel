import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/crop_stage_model.dart';

class CropStageProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
              final detailDocs = await detailsCollection.get();

              Map<String, dynamic> activityData = activity.data();

              int duration = activityData['duration'] ?? 0;

              List<Activity> activities = detailDocs.docs
                .where((doc) => doc.exists)
                .map((doc) {
                  return Activity.fromJson(doc.data());
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

    } catch (e, s) {
      log('Error fetching crop stages..!!\n$e\n$s');
    } finally {
      setFetchingStages(false);
    }
  }
}