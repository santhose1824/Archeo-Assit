import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/BlogScreens/BlogScreen.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/MainScreens/ChatbotScreen/ChatScreen.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/ProfileScreen/ProfileScreeen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'BottomNaviagtionBar/MainScreens/MainScreen.dart';
import 'BottomNaviagtionBar/ChatsScreens/SingleChatScreen/SinglePersonChatScreen.dart';

class HomeScreen extends StatefulWidget {
  final userId;
  HomeScreen({this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            SinglePersonChatScreen(userId: widget.userId,),
            BlogScreen(userId:widget.userId),
            MainScreen(userId: widget.userId,),
            ChatbotScreen(),
            ProfileScreen()
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.person, size: 30, color: Colors.white),
            Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            Icon(Icons.dashboard, size: 30, color: Colors.white),
            Icon(Icons.chat,color:Colors.white,size: 30,),
            Icon(
              Icons.person_4_rounded,
              size: 30,
              color: Colors.white,
            ),
          ],
          color: ColorManager.GridColor,
          buttonBackgroundColor: ColorManager.AppTextColor,
          backgroundColor: ColorManager.primaryBackgroundColor,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
