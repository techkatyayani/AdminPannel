import 'dart:developer';

import 'package:adminpannal/Screens/state_crops/model/crop_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StateCropProvider with ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  /// ALL CROPS

  bool _fetchingCrops = false;
  bool get fetchingCrops => _fetchingCrops;
  void setFetchingCrops(bool value) {
    _fetchingCrops = value;
    notifyListeners();
  }

  final List<CropModel> _crops = [];
  List<CropModel> get crops => _crops;

  Future<void> fetchCrops() async {
    try {
      setFetchingCrops(true);

      _crops.clear();
      notifyListeners();

      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('product').get();

      for (var doc in snapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data();
          data['id'] = doc.id;
          CropModel crop = CropModel.fromJson(data);
          _crops.add(crop);
        }
      }

      _crops.sort((a, b) => a.name.compareTo(b.name));

      notifyListeners();

    } catch (e, s) {
      log('Error fetching crops..!!\n$e\n$s');
    } finally {
      setFetchingCrops(false);
    }
  }

  /// SELECTED CROPS

  bool _fetchingCropsByState = false;
  bool get fetchingCropsByState => _fetchingCropsByState;
  void setFetchingCropsByState(bool value) {
    _fetchingCropsByState = value;
    notifyListeners();
  }

  List<CropModel> _availableCrops = [];
  List<CropModel> get availableCrops => _availableCrops;

  List<CropModel> _cropsInState = [];
  List<CropModel> get cropsInState => _cropsInState;

  void addCropsInState(CropModel crop) {
    _cropsInState.add(crop);

    _availableCrops.removeWhere((test) => test.id == crop.id);

    _availableCrops.sort((a, b) => a.name.compareTo(b.name));

    notifyListeners();
  }

  void removeCropsInState(CropModel crop) {
    _cropsInState.removeWhere((test) => test.id == crop.id);

    _availableCrops.add(crop);

    _availableCrops.sort((a, b) => a.name.compareTo(b.name));

    notifyListeners();
  }

  Future<void> fetchCropsByState(String state) async {
    try {

      _cropsInState.clear();
      notifyListeners();

      log('Crop in State Reset = $cropsInState');

      setFetchingCropsByState(true);

      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection('Crops By State').doc(state).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;

        List<String> crops = List<String>.from(data['crops'] ?? []);

        List<CropModel> stateCrops = [];

        for (var crop in crops) {
          int index = _crops.indexWhere((test) => test.id == crop);
          if (index != -1) {
            stateCrops.add(_crops[index]);
          }
        }

        _cropsInState = stateCrops;
        notifyListeners();

        _cropsInState.sort((a, b) => a.name.compareTo(b.name));

        log('Fetched Crops In State = $_cropsInState');
      }

      _availableCrops = _crops.toList();
      log('Available Crops Length Reset = ${_availableCrops.length}');
      notifyListeners();

      for (var crop in _cropsInState) {
        _availableCrops.removeWhere((test) {
          log('Crops Removed ${test.name}');
          return crop.id == test.id;
        });
      }

      log('Available Crops Length = ${_availableCrops.length}');

      notifyListeners();

    } catch (e, s) {
      log('Error fetching crops by state..!!\n$e\n$s');
    } finally {
      setFetchingCropsByState(false);
    }
  }

  Future<bool> saveCropsInState(String state) async {
    try {
      DocumentReference<Map<String, dynamic>> ref = firestore.collection('Crops By State').doc(state);

      await ref.set({
       'crops': cropsInState.map((crop) => crop.id),
      });

      _cropsInState.clear();
      notifyListeners();

      return true;
      
    } catch (e, s) {
      log('Error saving crops in state..!!\n$e\n$s');
      return false;
    }
  }
}