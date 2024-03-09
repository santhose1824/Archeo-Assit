import 'package:archeoassist/Screens/Auth/LoginScreen.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/MainScreens/GridScreens/Anticrafts/AncientArticrafts.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/MainScreens/GridScreens/ArcheaologyNews/ArcheaologyNews.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/MainScreens/GridScreens/ArcheaologyPlaces/ArcheaologyPlaces.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/MainScreens/GridScreens/Inscription/InscriptionDetection.dart';
import 'package:archeoassist/Screens/HomeScreens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Archeo-Assist',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
          '/inscriptionDetection': (context) => InscriptionDetection(),
          '/ancientArticrafts' :(context)=> AncientArticrafts(),
          '/News' :(context) => ArcheaologyNews(),
          '/Places': (context)=>ArcheaologyPlaces()
        },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnapshot) {
          if (usersnapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}

