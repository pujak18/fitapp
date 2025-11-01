import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// Firebase imports - will fail gracefully if Firebase not initialized
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Initialize Firebase services with null safety
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  bool _firebaseAvailable = false;

  AuthService() {
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      // Check if Firebase is actually initialized
      _firebaseAvailable = _auth != null && _firestore != null;
    } catch (e) {
      _firebaseAvailable = false;
      if (kDebugMode) {
        print('Firebase services not available: $e');
      }
    }
  }

  // Get current user
  User? get currentUser => _auth?.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges {
    if (_firebaseAvailable && _auth != null) {
      return _auth!.authStateChanges();
    }
    return const Stream.empty();
  }

  // Register with email and password
  Future<Map<String, dynamic>> registerWithEmail(
    String email,
    String password,
    String fullName,
  ) async {
    if (!_firebaseAvailable || _auth == null || _firestore == null) {
      // Fallback: Use SharedPreferences only
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', fullName);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', 'local_${DateTime.now().millisecondsSinceEpoch}');
      return {'success': true, 'message': 'Account created successfully'};
    }

    try {
      // Create user
      final userCredential = await _auth!
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user?.updateDisplayName(fullName);

      // Store user data in Firestore
      await _firestore!.collection('users').doc(userCredential.user!.uid).set({
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
    if (!_firebaseAvailable || _auth == null || _firestore == null) {
      // Fallback: Check SharedPreferences for local user
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('userEmail');
      
      if (savedEmail == email) {
        await prefs.setBool('isLoggedIn', true);
        return {'success': true, 'message': 'Signed in successfully'};
      }
      return {'success': false, 'message': 'Invalid email or password.'};
    }

    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(
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
    
    if (_firebaseAvailable && _auth != null) {
      try {
        await _auth!.signOut();
      } catch (e) {
        if (kDebugMode) {
          print('Error signing out from Firebase: $e');
        }
      }
    }
  }

  // Get user data from Firestore or SharedPreferences
  Future<Map<String, dynamic>?> getUserData() async {
    if (!_firebaseAvailable || _auth == null || _firestore == null) {
      // Fallback: Get from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userName = prefs.getString('userName') ?? 'Puja Kashyap';
      final userEmail = prefs.getString('userEmail') ?? '';
      
      if (userId == null || !(prefs.getBool('isLoggedIn') ?? false)) {
        return null;
      }

      return {
        'uid': userId,
        'fullName': userName,
        'email': userEmail,
        'totalSessions': prefs.getInt('totalSessions') ?? 0,
        'totalMinutes': prefs.getInt('totalMinutes') ?? 0,
        'currentStreak': prefs.getInt('currentStreak') ?? 0,
        'longestStreak': prefs.getInt('longestStreak') ?? 0,
        'level': prefs.getString('fitnessLevel') ?? 'Beginner',
      };
    }

    try {
      if (currentUser == null) {
        return null;
      }

      final doc = await _firestore!
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data;
      }

      // If user doesn't exist in Firestore but is logged in, create their data
      if (currentUser != null) {
        await _firestore!.collection('users').doc(currentUser!.uid).set({
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
        final newDoc = await _firestore!
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        return newDoc.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      // Return fallback data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userName = prefs.getString('userName') ?? 'Puja Kashyap';
      final userEmail = prefs.getString('userEmail') ?? '';
      
      if (userId == null) {
        return null;
      }

      return {
        'uid': userId,
        'fullName': userName,
        'email': userEmail,
        'totalSessions': prefs.getInt('totalSessions') ?? 0,
        'totalMinutes': prefs.getInt('totalMinutes') ?? 0,
        'currentStreak': prefs.getInt('currentStreak') ?? 0,
        'longestStreak': prefs.getInt('longestStreak') ?? 0,
        'level': prefs.getString('fitnessLevel') ?? 'Beginner',
      };
    }
  }

  // Update user workout stats
  Future<void> updateWorkoutStats(int minutes) async {
    if (!_firebaseAvailable || _auth == null || _firestore == null) {
      // Fallback: Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final currentSessions = prefs.getInt('totalSessions') ?? 0;
      final currentMinutes = prefs.getInt('totalMinutes') ?? 0;
      final currentStreak = prefs.getInt('currentStreak') ?? 0;
      
      await prefs.setInt('totalSessions', currentSessions + 1);
      await prefs.setInt('totalMinutes', currentMinutes + minutes);
      await prefs.setInt('currentStreak', currentStreak + 1);
      return;
    }

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

      await _firestore!.collection('users').doc(currentUser!.uid).update({
        'totalSessions': FieldValue.increment(1),
        'totalMinutes': FieldValue.increment(minutes),
        'currentStreak': newStreak,
        'lastWorkoutDate': now.toIso8601String(),
      });

      // Update longest streak if necessary
      if (userData != null) {
        final longestStreak = userData['longestStreak'] ?? 0;
        if (newStreak > longestStreak) {
          await _firestore!.collection('users').doc(currentUser!.uid).update({
            'longestStreak': newStreak,
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating workout stats: $e');
      }
    }
  }
}
