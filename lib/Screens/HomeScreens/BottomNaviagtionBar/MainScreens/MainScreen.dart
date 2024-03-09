import 'package:archeoassist/Color.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final userId;
  MainScreen({required this.userId});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorManager.primaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  size: 50,
                  color: ColorManager.GridColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                List<String> textList = [
                  'Inscription Detection',
                  'Ancient Articrafts',
                  'Archeaology News',
                  'Archeaology Places',
                ];

                // Routes for each grid item
                List<String> routes = [
                  '/inscriptionDetection',
                  '/ancientArticrafts',
                  '/News',
                  '/Places',
                ];

                return InkWell(
                  onTap: () {
                    // Navigate to the corresponding screen based on the index
                    Navigator.pushNamed(context, routes[index]);
                  },
                  child: GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorManager.GridColor,
                        border: Border.all(
                          color: Color.fromRGBO(24, 119, 242, 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(5.0, 5.0),
                            blurRadius: 3.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            textList[index].split(' ')[0], // First name
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                              height: 5), // Adjust the spacing between lines
                          Text(
                            textList[index].split(' ')[1], // Second name
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
