
import 'package:adminpannal/Screens/Category/controller/category_provider.dart';
import 'package:adminpannal/Screens/Category/row_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/category.dart';

class CategoryScreen extends StatefulWidget {
  
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  late CategoryProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CategoryProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          const SizedBox(height: 20),

          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),

          const SizedBox(height: 25),

          StreamBuilder(
            stream: provider.fetchCategoryRows(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              }
              else if (snapshot.hasError) {
                return Text(
                  'Error Fetching Categories\n${snapshot.error}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),
                );
              }
              else if (!snapshot.hasData || snapshot.data == null) {
                return const Text(
                  'No Data Available..!!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                );
              }

              List<List<Category>> data = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {

                  final List<Category> categories = data[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white60.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: GestureDetector(
                      onTap: () {

                        // provider.initCategoryData(categories);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RowCategoryScreen(categoryIndex: index)),
                        );

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailScreen(
                        //   index: index
                        // )));
                      },
                      child: Text(
                        'Category Row ${index+1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                        ),
                      ),
                    ),
                  );
                }
              );
            }
          ),

          const SizedBox(height: 25),

          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NOTE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Text(
                  '1. The First Row should contains categories like Fertilizers, Pesticides, Insecticides, Herbicides or Fungicides',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  '2. The Second and Third Row may contains any type of category like Offers, Seasonal Products, etc.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  '3. The Collection ID must be entered in proper format (e.g. - 456492089640)',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
