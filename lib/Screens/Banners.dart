import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  late Future<Map<String, dynamic>> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = getImage();
  }

  Future<Map<String, dynamic>> getImage() async {
    final DocumentReference user1 = FirebaseFirestore.instance
        .collection('imagefromfirebase')
        .doc('Category');
    try {
      DocumentSnapshot userSnapshot = await user1.get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner Screen'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {

            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> userData = snapshot.data ?? {};
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200
                    ),
                    child: Text('Hindi Slide Banner\'s'),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: NetworkImage(userData['150 product hindi.jpg'] ?? '',),
                        height:100,
                        width: 200,
                      ),
                      Image(
                        image: NetworkImage(userData['best selling hindi.jpg'] ?? '',),
                        height:100,
                        width: 200,
                      ),
                      Image(
                        image: NetworkImage(userData['agri advisor hindi.jpg'] ?? '',),
                        height:100,
                        width: 200,
                      ),
                      Image(
                        image: NetworkImage(userData['crop calender hindi.jpg'] ?? '',),
                        height:100,
                        width: 200,
                      ),
                    ],
                  ),
                ],
              )
            );
          }
        },
      ),
    );
  }
}
