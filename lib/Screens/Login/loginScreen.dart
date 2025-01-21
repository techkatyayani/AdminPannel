import 'package:adminpannal/Screens/Dashboard/dashboard.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isPasswordVisible = false;

  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    if (passwordFocusNode.hasFocus && !isPasswordVisible) {
      isHandsUp?.change(true);
    } else {
      isHandsUp?.change(false);
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
      isHandsUp?.change(!isPasswordVisible);
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('AdminUsers').where('email', isEqualTo: email).limit(1).get();

    if (snapshot.docs.isEmpty) {
      Utils.showSnackBar(context: context, message: 'No User Found..!!');
      setState(() {
        isLoading = false;
      });
      return;
    }

    QueryDocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;

    if (doc.exists) {

      Map<String, dynamic> data = doc.data();

      String savedPassword = data['password'] ?? '';

      if (savedPassword == password) {
        setState(() {
          isLoading = false;
        });

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool('LOGIN', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashBoard(),
          ),
        );
      } else {
        Utils.showSnackBar(context: context, message: 'Invalid Password..!!');
        setState(() {
          isLoading = false;
        });
        return;
      }

    } else {
      Utils.showSnackBar(context: context, message: 'No User Found..!!');
      setState(() {
        isLoading = false;
      });
      return;
    }



    // if ((email == 'marketing900' || email == 'prateek') && (password == 'm900' || password == 'prateek')) {
    //
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   await pref.setBool('LOGIN', true);
    //
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const DashBoard(),
    //     ),
    //   );
    //
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Wrong Credentials"),
    //     ),
    //   );
    // }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .1),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFD6E2EA),
            child: Column(
              children: [

                SizedBox(height: height * 0.05),

                const Text(
                  "Krishi Seva Kendra\nAdmin Login",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  height: height * .4,
                  width: width * .4,
                  child: RiveAnimation.asset(
                    "assets/images/login-teddy.riv",
                    fit: BoxFit.fitHeight,
                    stateMachines: const ["Login Machine"],
                    onInit: (artboard) {
                      controller = StateMachineController.fromArtboard(
                        artboard,
                        "Login Machine",
                      );
                      if (controller == null) return;

                      artboard.addController(controller!);
                      isChecking = controller?.findInput("isChecking");
                      numLook = controller?.findInput("numLook");
                      isHandsUp = controller?.findInput("isHandsUp");
                      trigSuccess = controller?.findInput("trigSuccess");
                      trigFail = controller?.findInput("trigFail");
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2, bottom: width * 0.05),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: TextField(
                            focusNode: emailFocusNode,
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                )),
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            onChanged: (value) {
                              numLook?.change(value.length.toDouble());
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: TextField(
                            focusNode: passwordFocusNode,
                            controller: passwordController,
                            decoration: InputDecoration(
                              iconColor: Colors.black,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                color: Colors.black,
                                onPressed: togglePasswordVisibility,
                              ),
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                color: Colors.black38,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            obscureText: !isPasswordVisible,
                            onChanged: (value) {},
                            onSubmitted: (value) {
                              login();
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
