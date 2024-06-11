import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreenLayout extends StatefulWidget {
  const HomeScreenLayout({super.key});

  @override
  State<HomeScreenLayout> createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends State<HomeScreenLayout> {
  bool _isLoading = false;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _englishImageName = TextEditingController();
  final TextEditingController _hindiImageName = TextEditingController();
  Future<int> _getNextDocNumber() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('HomeLayout')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      int lastDocNumber = int.parse(snapshot.docs.first['id']);
      return lastDocNumber + 1;
    } else {
      return 1;
    }
  }

  void _addData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    String name = _nameController.text;
    String collectionId = _idController.text;

    int nextDocNumber = await _getNextDocNumber();
    String id = nextDocNumber.toString();

    if (name.isNotEmpty) {
      CollectionReference homeLayoutCollection =
          FirebaseFirestore.instance.collection('HomeLayout');

      try {
        await homeLayoutCollection.doc(id).set({
          'id': id,
          'name': name,
          'collectionId': collectionId,
          'englishImageName': _englishImageName.text,
          'hindiImageName': _hindiImageName.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data added successfully'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add data: $e'),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a name'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Collection"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          // height: size.height * .7,
          width: size.width * .3,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(38, 40, 55, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "+ Add Collection",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: size.width * .012),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Collection ID'),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Collection Name'),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _englishImageName,
                decoration:
                    const InputDecoration(labelText: 'English Image Name'),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _hindiImageName,
                decoration:
                    const InputDecoration(labelText: 'Hindi Image Name'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _addData(context),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Add Collection',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
