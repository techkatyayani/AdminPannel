import 'dart:developer';

import 'package:adminpannal/Utils/app_language.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class YoutubeVideosScreen extends StatefulWidget {
  const YoutubeVideosScreen({super.key});

  @override
  State<YoutubeVideosScreen> createState() => _YoutubeVideosScreenState();
}

class _YoutubeVideosScreenState extends State<YoutubeVideosScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  bool isFetching = false;

  Map<String, List<String>> links = {};

  Map<String, List<TextEditingController>> controllers = {};

  @override
  void initState() {
    super.initState();
    fetchLinks();
  }

  Future<void> fetchLinks() async {

    setState(() => isFetching = true);

    try {
      
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection('DynamicSection').doc('Youtube_Ids').get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;

        for (var entry in AppLanguage.languageCodeToName.entries) {

          String code = entry.key;
          String language = entry.value;

          List<dynamic> ids = data['id_$code'] ?? [];

          links[language] = ids.map((id) => id.toString()).toList();

          controllers[language] = [];

          links[language]!.map((test) {

            String id = test.toString();

            controllers[language]!.add(TextEditingController(text: id));

            return id;

          }).toList();
        }
      }
      
    } catch (e, stace) {
      log('Error fetching youtube links :(\n$e\n$stace');
    }

    setState(() => isFetching = false);
    
  }

  Future<void> saveLinks() async {
    try {

      Utils.showLoadingBox(context: context, title: 'Saving Links...');

      DocumentReference<Map<String, dynamic>> snapshot = firestore.collection('DynamicSection').doc('Youtube_Ids');

      Map<String, dynamic> data = {};

      for (var controller in controllers.entries) {

        String key = AppLanguage.languageNameToCode[controller.key]!;
        List<TextEditingController> ids = controller.value;

        List<String> ytIds = [];

        for (var id in ids) {
          String yt = id.text.trim();
          ytIds.add(yt);
        }

        data['id_$key'] = ytIds;
      }

      await snapshot.set(data);

    } catch (e, stace) {
      log('Error saving youtube links :(\n$e\n$stace');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> deleteLink(String key, int index) async {
    try {

      DocumentReference<Map<String, dynamic>> snapshot = firestore.collection('DynamicSection').doc('Youtube_Ids');

      List<TextEditingController> ids = controllers[key]!;

      List<String> links = [];

      for (var link in ids) {
        String id = link.text.trim();
        links.add(id);
      }

      String removedLink = links.removeAt(index);

      log("Removed Link - $removedLink");

      Utils.showLoadingBox(context: context, title: 'Deleting $removedLink...');

      await snapshot.set({
        'id_${AppLanguage.languageNameToCode[key]}': links,
      },
        SetOptions(merge: true),
      );

      controllers[key]!.removeAt(index);

    } catch (e, stace) {
      log('Error deleting youtube links :(\n$e\n$stace');
    } finally {
      Navigator.pop(context);
      Navigator.pop(context);

      setState(() {});
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Text(
              'Youtube Videos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            isFetching
                ?
            const CircularProgressIndicator(
              color: Colors.white,
            )
                :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Note :- You need to write just id of youtube video.',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            'For instance - for video link "https://www.youtube.com/embed/0CyW8I7lRgA", you need to write only "0CyW8I7lRgA"',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey
                            ),
                          ),

                        ],
                      ),

                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            saveLinks();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  itemCount: controllers.entries.length,
                  itemBuilder: (context, i) {

                    final entry = controllers.entries.toList()[i];

                    String language = entry.key;
                    List<TextEditingController> ids = entry.value;

                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: boxColor
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            language,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange
                            ),
                          ),

                          const SizedBox(height: 10),

                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ids.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                    '${index+1}.',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  customTextField(controller: ids[index]),

                                  const SizedBox(width: 10),

                                  IconButton(
                                      onPressed: () {
                                        Utils.showConfirmBox(
                                          context: context,
                                          message: 'Are you sure to delete youtube video..!!',
                                          onConfirm: () {
                                            deleteLink(language, index);
                                          },
                                          onCancel: () {
                                            Navigator.pop(context);
                                          },
                                          confirmText: 'Delete'
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                          ),

                          const SizedBox(height: 10),

                          InkWell(
                            onTap: () {
                              setState(() {
                                controllers[language]!.add(TextEditingController());
                              });
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
                                '+  Add More Links',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 25);
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
  }) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                'https://www.youtube.com/embed/',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextFormField(
                controller: controller,
                cursorColor: Colors.white,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                validator: (string) {
                  if (controller.text.trim().isEmpty) {
                    return 'Link is required..!!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  hintText: 'Enter video id here..',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  errorStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                  border: _customBorder(),
                  enabledBorder: _customBorder(),
                  disabledBorder: _customBorder(),
                  focusedBorder: _customBorder(width: 2),
                  focusedErrorBorder: _customBorder(color: Colors.red, width: 2),
                  errorBorder: _customBorder(color: Colors.red)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  UnderlineInputBorder _customBorder({double? width, Color? color}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color ?? Colors.transparent,
        width: width ?? 0,
      ),
    );
  }
}
