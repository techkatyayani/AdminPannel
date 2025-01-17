import 'package:adminpannal/Screens/state_crops/controller/state_crop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/crop_model.dart';

class StateCropSelectionScreen extends StatefulWidget {

  final StateCropProvider provider;
  final String state;

  const StateCropSelectionScreen({super.key, required this.provider, required this.state});

  @override
  State<StateCropSelectionScreen> createState() => _StateCropSelectionScreenState();
}

class _StateCropSelectionScreenState extends State<StateCropSelectionScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.provider.fetchCropsByState(widget.state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          '${widget.state} Crops',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<StateCropProvider>(
        builder: (context, StateCropProvider provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: provider.fetchingCropsByState
                ?
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
                :
            Column(
              children: [
                provider.cropsInState.isEmpty
                    ?
                Center(
                  child: Text(
                    'No Crops found for ${widget.state}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                )
                    :
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: provider.cropsInState.map((crop) {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Image.network(
                                  crop.image,
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height: MediaQuery.of(context).size.width * 0.15,
                                  errorBuilder: (context, error, stace) {
                                    return const Icon(
                                      Icons.error,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 5,),

                              Text(
                                crop.name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                ),
                              )
                            ],
                          ),

                          Positioned(
                            top: -5,
                            right: -5,
                            child: Card(
                              elevation: 3,
                              color: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  provider.removeCropsInState(crop);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: provider.availableCrops.length,
                    itemBuilder: (context, index) {
                      CropModel crop = provider.availableCrops[index];
                      return InkWell(
                        onTap: () {
                          provider.addCropsInState(crop);
                        },
                        child: Card(
                          elevation: 14,
                          color: Colors.white,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.network(
                                  crop.image,
                                  width: MediaQuery.of(context).size.width * 0.1,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stace) {
                                    return const Icon(
                                      Icons.error
                                    );
                                  },
                                ),

                                Text(
                                  crop.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
