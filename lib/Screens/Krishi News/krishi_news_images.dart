import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/Screens/Krishi%20News/model/krishi_news_model.dart';
import 'package:adminpannal/Screens/Krishi%20News/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KrishiNewsImages extends StatefulWidget {

  const KrishiNewsImages({super.key});

  @override
  State<KrishiNewsImages> createState() => _KrishiNewsImagesState();
}

class _KrishiNewsImagesState extends State<KrishiNewsImages> {

  late KrishiNewsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<KrishiNewsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: provider.fetchPost('image'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        }
        else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching Krishi Post Images..!!\n${snapshot.error}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red
              ),
            ),
          );
        }
        else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              'No Krishi Post Images available..!!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          );
        }

        List<KrishiNewsModel> data = snapshot.data!;

        return GridView.builder(

          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),

          itemCount: data.length,
          itemBuilder: (context, index) {

            KrishiNewsModel post = data[index];

            return PostCard(
              mediaType: 'image',
              post: post,
            );
          }
        );

      }
    );
  }
}
