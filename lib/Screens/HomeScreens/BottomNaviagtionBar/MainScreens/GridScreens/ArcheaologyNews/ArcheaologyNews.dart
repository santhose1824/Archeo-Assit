import 'package:archeoassist/Color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ArcheaologyNews extends StatefulWidget {
  const ArcheaologyNews({Key? key}) : super(key: key);

  @override
  State<ArcheaologyNews> createState() => _ArcheaologyNewsState();
}

class _ArcheaologyNewsState extends State<ArcheaologyNews> {
  late Future<List<Map<String, String>>> newsList;

  @override
  void initState() {
    super.initState();
    newsList = fetchNewsFromFirestore();
  }

  // ...

// ...

Future<List<Map<String, String>>> fetchNewsFromFirestore() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('news').get();

  List<Map<String, String>> newsDataList = querySnapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return {
      'title': (data['description'] ?? '') as String,
      'description': (data['info'] ?? '') as String,
      'imagePath': (data['imageUrl'] ?? '') as String,
    };
  }).toList();

  return newsDataList;
}

// ...


// ...

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: FutureBuilder<List<Map<String, String>>>(
          future: newsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return buildNewsListView(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget buildNewsListView(List<Map<String, String>> newsList) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Today's News",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  return _buildNewsCard(
                    context,
                    newsList[index]['title']!,
                    newsList[index]['description']!,
                    newsList[index]['imagePath']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to the detailed view when the card is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailView(title, description, imagePath),
                  ),
                );
              },
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                height: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Navigate to the detailed view when the arrow icon button is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailView(title, description, imagePath),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: ColorManager.AppTextColor,
                      ),
                    ),
                  ],
                ),

                  SizedBox(height: 8.0),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsDetailView extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  NewsDetailView(this.title, this.description, this.imagePath);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: ColorManager.AppTextColor, // Change to your desired color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Today's",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'News',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40,),
                Container(
                  decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          height: 300.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black.withOpacity(0.3), // Adjust the opacity as needed
                          ),
                          height:150.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    color: ColorManager.GridColor,
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.GridColor.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


