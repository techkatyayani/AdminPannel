import 'package:adminpannal/Screens/Similar%20Products/controller/similar_products_provider.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SimilarProductIdScreen extends StatefulWidget {

  final String productId;

  const SimilarProductIdScreen({super.key, required this.productId});

  @override
  State<SimilarProductIdScreen> createState() => _SimilarProductIdScreenState();
}

class _SimilarProductIdScreenState extends State<SimilarProductIdScreen> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SimilarProductsProvider>(
      builder: (context, provider, child) {
        return Form(
          key: formKey,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: const Text('Product IDs'),
              actions: [

                ElevatedButton(
                    onPressed: () async {

                      if (formKey.currentState!.validate()) {

                        Utils.showLoadingBox(context: context, title: 'Saving Product Ids...');

                        bool isSaved = await provider.saveSimilarProductsIds(docId: widget.productId);

                        Navigator.pop(context);

                        if (isSaved) {
                          Navigator.pop(context);
                          Utils.showSnackBar(context: context, message: 'Product Ids updated successfully :)');
                        }
                      } else {
                        Utils.showSnackBar(context: context, message: 'Please enter product id..!!');
                      }


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                ),

                const SizedBox(width: 20),
              ],
            ),
            body: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              itemCount: provider.productControllers.length + 1,
              itemBuilder: (context, index) {

                if (index == provider.productControllers.length) {
                  return InkWell(
                    onTap: () {
                      provider.addProductController();
                    },
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.fromBorderSide(BorderSide(
                              color: Colors.grey.shade200
                          ))
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '+ Add More Ids',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  );
                }

                TextEditingController controller = provider.productControllers[index];

                return Row(
                  children: [
                    Text(
                      '${index+1}.',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                      )
                    ),

                    const SizedBox(width: 20),

                    Flexible(
                      child: CustomTextField(
                        controller: controller,
                        hintText: 'Product Id',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    IconButton(
                      onPressed: () {
                        provider.removeProductController(index);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )
                    )
                  ],
                );

              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            ),
          ),
        );
      }
    );
  }
}
