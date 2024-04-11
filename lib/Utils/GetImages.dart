import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getImage() async {
  final DocumentReference user1 = FirebaseFirestore.instance
      .collection('imagefromfirebase')
      .doc('Category');
  try {
    DocumentSnapshot userSnapshot = await user1.get();
    return userSnapshot.data() as Map<String, dynamic>;
  } catch (e) {
    print(e.toString());
  }
  return {};
}