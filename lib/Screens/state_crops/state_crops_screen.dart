import 'package:adminpannal/Screens/state_crops/controller/state_crop_provider.dart';
import 'package:adminpannal/Screens/state_crops/state_crop_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StateCropsScreen extends StatefulWidget {
  const StateCropsScreen({super.key});

  @override
  State<StateCropsScreen> createState() => _StateCropsScreenState();
}

class _StateCropsScreenState extends State<StateCropsScreen> {

  late StateCropProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<StateCropProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.fetchCrops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 5, left: 5),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.states.length,
      itemBuilder: (context, index) {
        String state = provider.states[index];

        return Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromRGBO(38, 40, 55, 1),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StateCropSelectionScreen(
                    provider: provider,
                    state: state,
                  ))
              );
            },
            child: Row(
              children: [
                Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(width: 20),

                Text(
                  state,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.white,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
