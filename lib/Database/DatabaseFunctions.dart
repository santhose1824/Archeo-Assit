import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;

      if (user != null) {
        // Add the new user to Firestore
        await addUserToFirestore(user.uid, email, '', '');
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addUserToFirestore(
      String uid, String email, String imageUrl, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>?> signInWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = authResult.user;

    if (user != null) {
      // Fetch user document ID and other data
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();

      if (userData.exists) {
        String documentId = userData.id;
        String name = userData['name'];
        String email = userData['email'];
        String imageUrl = userData['imageUrl'];

        // Return a map containing both user data and document ID
        return {
          'user': user,
          'documentId': documentId,
          'name': name,
          'email': email,
          'imageUrl': imageUrl,
        };
      }
    }

    return null;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(uid).get();
      return userData.data() as Map<String, dynamic>?;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> getUserDataAndUpdateState(String uid,
      Function(String?, String?, String?) updateStateCallback) async {
    try {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(uid).get();
      if (userData.exists) {
        String name = userData['name'];
        String email = userData['email'];
        String imageUrl = userData['imageUrl'];
        updateStateCallback(name, email, imageUrl);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  

  Future<List<Map<String, dynamic>>?> getMapLocations() async {
    try {
      QuerySnapshot locationsSnapshot =
          await _firestore.collection('maps').get();

      List<Map<String, dynamic>> locations =
          locationsSnapshot.docs.map((DocumentSnapshot document) {
        return {
          'lat': document['lat'],
          'long': document['long'],
          'placeName': document['placeName'],
          'details': document['details'],
          'year': document['year'], // Add the 'year' field
          // Add other details as needed
        };
      }).toList();
      print(locations);
      return locations;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}