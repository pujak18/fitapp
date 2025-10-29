import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<Map<String, dynamic>> registerWithEmail(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      // Create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user?.updateDisplayName(fullName);

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'fullName': fullName,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
        'totalSessions': 0,
        'totalMinutes': 0,
        'currentStreak': 0,
        'longestStreak': 0,
        'lastWorkoutDate': null,
        'fitnessLevel': 'beginner',
      });

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', fullName);
      await prefs.setBool('isLoggedIn', true);

      return {'success': true, 'message': 'Account created successfully'};
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', userCredential.user!.displayName ?? '');
      await prefs.setBool('isLoggedIn', true);

      return {'success': true, 'message': 'Signed in successfully'};
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Sign out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await _auth.signOut();
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (currentUser == null) {
        print('No current user found');
        return null;
      }

      print('Getting user data for: ${currentUser!.uid}');
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print('User data retrieved: $data');
        return data;
      }

      // If user doesn't exist in Firestore but is logged in, create their data
      if (currentUser != null) {
        print('User not found in Firestore, creating user data...');
        await _firestore.collection('users').doc(currentUser!.uid).set({
          'uid': currentUser!.uid,
          'fullName':
              currentUser!.displayName ??
              currentUser!.email?.split('@').first ??
              'User',
          'email': currentUser!.email ?? '',
          'createdAt': DateTime.now().toIso8601String(),
          'totalSessions': 0,
          'totalMinutes': 0,
          'currentStreak': 0,
          'longestStreak': 0,
          'lastWorkoutDate': null,
          'fitnessLevel': 'beginner',
        });

        // Return the newly created data
        final newDoc = await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        return newDoc.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update user workout stats
  Future<void> updateWorkoutStats(int minutes) async {
    try {
      if (currentUser == null) return;

      final userData = await getUserData();
      final now = DateTime.now();

      // Check if it's a new day for streak calculation
      int newStreak = 0;
      if (userData != null) {
        final lastWorkoutDate = userData['lastWorkoutDate'];
        if (lastWorkoutDate != null) {
          final lastDate = DateTime.parse(lastWorkoutDate);
          final daysDiff = now.difference(lastDate).inDays;

          if (daysDiff == 0) {
            newStreak = userData['currentStreak'] ?? 0;
          } else if (daysDiff == 1) {
            newStreak = (userData['currentStreak'] ?? 0) + 1;
          } else {
            newStreak = 1;
          }
        } else {
          newStreak = 1;
        }
      } else {
        newStreak = 1;
      }

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'totalSessions': FieldValue.increment(1),
        'totalMinutes': FieldValue.increment(minutes),
        'currentStreak': newStreak,
        'lastWorkoutDate': now.toIso8601String(),
      });

      // Update longest streak if necessary
      if (userData != null) {
        final longestStreak = userData['longestStreak'] ?? 0;
        if (newStreak > longestStreak) {
          await _firestore.collection('users').doc(currentUser!.uid).update({
            'longestStreak': newStreak,
          });
        }
      }
    } catch (e) {
      print('Error updating workout stats: $e');
    }
  }
}
