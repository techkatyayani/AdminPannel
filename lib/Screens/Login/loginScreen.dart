import 'package:adminpannal/Screens/Dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  /// input form controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  /// rive controller and input
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
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
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
                SizedBox(height: height * .05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image(
                      //   height: MediaQuery.sizeOf(context).height * .1,
                      //   image: const AssetImage(
                      //     'assets/images/icon.png',
                      //   ),
                      // ),
                      const SizedBox(width: 20),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Admin Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * .4,
                  width: height * .4,
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
                  padding: EdgeInsets.only(
                      left: width * .2, right: width * .2, bottom: width * .05),
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
                        const SizedBox(height: 8),
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
                            decoration: const InputDecoration(
                              iconColor: Colors.black,
                              suffixIcon: Icon(
                                Icons.visibility_rounded,
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            obscureText: true,
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              emailFocusNode.unfocus();
                              passwordFocusNode.unfocus();

                              final email = emailController.text;
                              final password = passwordController.text;

                              if (email.isEmpty || password.isEmpty) {
                                showErrorDialog("Please fill all fields");
                                setState(() {
                                  isLoading = false;
                                });
                                return;
                              }

                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                final user = userCredential.user;
                                if (user != null) {
                                  // Store user data in Firestore
                                  await FirebaseFirestore.instance
                                      .collection('AdminUsers')
                                      .doc(user.uid)
                                      .set({
                                    'email': email,
                                    'uid': user.uid,
                                  });

                                  trigSuccess?.change(true);
                                  await Future.delayed(
                                    const Duration(milliseconds: 2000),
                                  );

                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: const DashBoard(),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                print(e);
                                trigFail?.change(true);
                                String errorMessage;
                                switch (e.code) {
                                  case 'user-not-found':
                                    errorMessage =
                                        "No user found for that email.";
                                    break;
                                  case 'wrong-password':
                                    errorMessage = "Wrong password provided.";
                                    break;
                                  default:
                                    errorMessage =
                                        "An error occurred. Please try again.";
                                }
                                showErrorDialog(errorMessage);
                              } catch (e) {
                                trigFail?.change(true);
                                showErrorDialog(
                                    "An error occurred. Please try again.");
                              }

                              setState(() {
                                isLoading = false;
                              });
                            },
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
