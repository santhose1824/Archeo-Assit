import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/MainScreens/GridScreens/Anticrafts/ResultPage1.dart';
import 'package:http/http.dart' as http;
import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/MainScreens/GridScreens/Inscription/TitleSection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
class AncientArticrafts extends StatefulWidget {
  const AncientArticrafts({super.key});

  @override
  State<AncientArticrafts> createState() => _AncientArticraftsState();
}

class _AncientArticraftsState extends State<AncientArticrafts> {
  File? _selectedImage;

  Future<void> _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _sendImageToServer(File image) async {
  String base64Image = await _imageToBase64(image);

  if (base64Image != null) {
    // Replace with your Flask server endpoint
    String serverUrl = 'http://192.168.43.66:5000/process_arti_image';

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: jsonEncode({'image': base64Image}),
        headers: {'Content-Type': 'application/json'},
      );

      // Handle server response and extract information
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String information =
            data['information']; // Adjust key based on your API response
        return information;
      } else {
        throw Exception('Failed to load information');
      }
    } catch (e) {
      print('Error sending image to server: $e');
      return 'Failed to load information';
    }
  } else {
    print('Base64 image is null');
    return 'Failed to load information';
  }
}



  Future<String> _imageToBase64(File image) async {
  // Convert image to JPEG format
  img.Image decodedImage = await _convertToJpeg(image);

  // Read image as bytes
  List<int> imageBytes = img.encodeJpg(decodedImage);

  // Encode as base64
  final base64Image = base64Encode(imageBytes);

  return base64Image;
}

Future<img.Image> _convertToJpeg(File image) async {
  // Read image
  List<int> imageBytes = await image.readAsBytes();
  img.Image decodedImage = img.decodeImage(Uint8List.fromList(imageBytes))!;

  // Convert image to JPEG format
  return decodedImage;
}


  Future<void> _navigateToResultPage(File image) async {
    String information = await _sendImageToServer(image);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultPage1(image: image, information: information),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleSection('Artificarfts Detection', size.height * 0.066),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 200,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorManager.AppTextColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'These are Instruction to be followed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              '1) Choose the picture or Capture the Picture by clicking the below Button',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              '2) Then Select or Capture the image of Inscription which you want to know the information about it',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _selectedImage != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Center(
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.black,
                              ),
                            ),
                            child: Image.file(
                              _selectedImage!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_selectedImage != null) {
                        await _navigateToResultPage(_selectedImage!);
                      } else {
                        print('No image selected');
                      }
                    },
                    child: Text('Detect'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF112A46),
                      onPrimary: ColorManager.primaryTextColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(370, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: ColorManager.AppTextColor,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0, color: Colors.white),
          closeManually: false,
          children: [
            SpeedDialChild(
              child: Icon(Icons.camera_alt, color: Colors.white),
              backgroundColor: ColorManager.GridColor,
              onTap: _getImageFromCamera,
              label: 'Camera',
              labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
              labelBackgroundColor: ColorManager.AppTextColor,
            ),
            SpeedDialChild(
              child: Icon(Icons.photo, color: Colors.white),
              backgroundColor: ColorManager.AppTextColor,
              onTap: _getImageFromGallery,
              label: 'Gallery',
              labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
              labelBackgroundColor: ColorManager.AppTextColor,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
