import 'dart:developer';

import 'package:adminpannal/Screens/Krishi%20News/model/krishi_news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KrishiNewsService {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<KrishiNewsModel>> fetchPost(String mediaType) async {
    try {

      QuerySnapshot<Map<String, dynamic>> collection = await firestore.collection('KrishiNewsPosts').where('mediaType', isEqualTo: mediaType).get();

      List<KrishiNewsModel?> feed = await Future.wait(collection.docs.map((doc) async {

          if (!doc.exists) return null;

          // Create KrishiNewsModel instance

          // log('Doc Data - ${doc.data()}');

          Map<String, dynamic> data = doc.data();

          KrishiNewsModel krishiNewsModel = KrishiNewsModel.fromJson(data);

          // Fetch comments for the post
          QuerySnapshot<Map<String, dynamic>> commentCollection = await firestore
              .collection('KrishiNewsPosts')
              .doc(doc.id)
              .collection('comments')
              .get();

          // Map comments to the Comments model
          List<Comments> comments = commentCollection.docs.map((commentDoc) {
            if (!commentDoc.exists) return null;
            return Comments.fromJson(commentDoc.data());
          }).whereType<Comments>().toList();

          return krishiNewsModel.copyWith(comments: comments);

        }).toList(),
      );

      List<KrishiNewsModel> krishiNews = feed.whereType<KrishiNewsModel>().toList();

      return krishiNews;

    } catch (e, stace) {
      log('Error fetching Krishi Posts...');
      log('Error is $e\nStace is $stace');
      return [];
    }
  }

}