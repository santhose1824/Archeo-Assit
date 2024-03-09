import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Database/DatabaseFunctions.dart';
import 'package:archeoassist/Screens/Auth/RegisterScreen.dart';
import 'package:archeoassist/Screens/HomeScreens/HomeScreen.dart';
import 'package:archeoassist/Widgets/AuthWidgets/AuthTextFeilds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DatabaseFunctions _databaseFunctions = DatabaseFunctions();
  void login() async {
  Map<String, dynamic>? loginResult = await _databaseFunctions.signInWithEmailAndPassword(
    emailController.text,
    passwordController.text,
  );

  if (loginResult != null) {
    User user = loginResult['user'];
    String documentId = loginResult['documentId'];
    
    // Use user, documentId, and other data as needed
    print('User ID: ${user.uid}');
    print('Document ID: $documentId');
    
    // Navigate to HomeScreen or perform other actions
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(userId:user.uid)));
  } else {
    // Handle login failure, show error message, etc.
    print('Login failed');
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Archeo-Assist',
                    style: TextStyle(
                        color: ColorManager.HeadingsColors,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                AuthFeilds(
                  controller: emailController,
                  hint: 'Enter your Email',
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  obsecureText: false,
                ),
                SizedBox(
                  height: 10,
                ),
                AuthFeilds(
                  controller: passwordController,
                  hint: 'Enter your Password',
                  icon: Icon(
                    Icons.key,
                    color: Colors.white,
                  ),
                  obsecureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF112A46),
                    onPrimary: ColorManager.primaryTextColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // BorderRadius
                    ),
                    minimumSize: Size(370, 50),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'or Continue with',
                  style: TextStyle(
                      color: ColorManager.HeadingsColors,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: 370,
                      decoration: BoxDecoration(
                          color: ColorManager.AppTextColor,
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.AppTextColor.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 90),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/g-logo.png',
                              height: 20,
                              width: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'Sign In with Google ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'If you New?',
                      style: TextStyle(
                        color: ColorManager.HeadingsColors,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => RegisterScree()));
                      },
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          color: ColorManager.AppTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
