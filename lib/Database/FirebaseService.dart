import 'dart:io';
import 'package:archeoassist/Database/DatabaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  DatabaseFunctions databaseFunctions = DatabaseFunctions();
  PostData _postFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    return PostData(
      postId: snapshot.id,
      userId: data['userId'],
      userName: data['userName'],
      userProfileImage: data['userProfileImage'],
      caption: data['caption'],
      imageUrl: data['imageUrl'],
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((comment) => CommentData.fromMap(comment))
          .toList(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Future<void> createPost(String caption, File imageFile) async {
  try {
    String imageUrl = await _uploadImage(imageFile);
    User? user = _auth.currentUser;
    String userId = user!.uid;

    // Retrieve user data from DatabaseFunctions
    Map<String, dynamic>? userData = await databaseFunctions.getUserData(userId);

    if (userData != null) {
      String userName = userData['name'];
      String userProfileImage = userData['imageUrl'];

      await _firestore.collection('posts').add({
        'userId': userId,
        'userName': userName,
        'userProfileImage': userProfileImage,
        'caption': caption,
        'imageUrl': imageUrl,
        'comments': [],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    print('Error creating post: $e');
  }
}


  Future<String> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = _storage.ref().child('images/$fileName.jpg');
      await storageReference.putFile(image);
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Stream<List<PostData>> getPosts() {
    return _firestore.collection('posts').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => _postFromSnapshot(doc)).toList(),
        );
  }

  Future<void> addComment(String postId, String comment) async {
    try {
      User? user = _auth.currentUser;
      String userId = user!.uid;

      await _firestore.collection('comments').doc(postId).update({
        'comments': FieldValue.arrayUnion([
          {
            'userId': userId,
            'comment': comment,
            'timestamp': FieldValue.serverTimestamp()
          }
        ]),
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}

class PostData {
  final String postId;
  final String userId;
  final String userName;
  final String userProfileImage;
  final String caption;
  final String imageUrl;
  final List<CommentData> comments;
  final DateTime timestamp;

  PostData({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.caption,
    required this.imageUrl,
    required List<CommentData>? comments,
    required this.timestamp,
  }) : this.comments = comments ?? [];

  PostData.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : postId = doc.id,
        userId = doc['userId'],
        userName = doc[
            'userName'], // You should retrieve the username from Firestore using 'userId'
        userProfileImage = doc[
            'userProfile'], // You should retrieve the user profile image URL from Firestore using 'userId'
        caption = doc['caption'],
        imageUrl = doc['imageUrl'],
        timestamp = (doc['timestamp'] as Timestamp).toDate(),
        comments = (doc['comments'] as List<dynamic>? ?? [])
            .map((comment) => CommentData.fromMap(comment))
            .toList();
}

class CommentData {
  final String userId;
  final String comment;
  final DateTime timestamp;

  CommentData({
    required this.userId,
    required this.comment,
    required this.timestamp,
  });

  CommentData.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        comment = map['comment'],
        timestamp = (map['timestamp'] as Timestamp).toDate();
}
