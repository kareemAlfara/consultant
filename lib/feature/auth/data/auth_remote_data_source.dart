
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marriage/feature/auth/data/models/userModel.dart';


class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // ========================================
  // ✅ SIGN UP
  // ========================================
  Future<UserModel> signup({
    
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      print('🔐 Starting signup for: $email');

      // 1. Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Update display name
      await userCredential.user!.updateDisplayName(name);

      // 3. Create user document in Firestore
      final userModel = UserModel(
        id: uid,
        email: email,
        name: name,
        phone: phone,
      );

      await _firestore.collection('users').doc(uid).set(userModel.toFirestore());

      print('✅ User created successfully: $uid');
      return userModel;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Signup error: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ SIGN IN
  // ========================================
  Future<UserModel> signin({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Signing in: $email');

      // 1. Sign in with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Get user data from Firestore
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception('User data not found');
      }

      final userModel = UserModel.fromFirestore(doc.data()!, uid);

      print('✅ Signed in successfully: $uid');
      return userModel;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Signin error: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ GOOGLE SIGN IN
  // ========================================
  Future<UserModel> signinWithGoogle() async {
    try {
      print('🔐 Starting Google Sign-In');

      // 1. Sign out first to force account picker
      await _googleSignIn.signOut();

      // 2. Trigger Google Sign-In flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      // 3. Get Google Auth credentials
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      // 5. Check if user exists in Firestore
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        // Existing user
        print('✅ Existing Google user: $uid');
        return UserModel.fromFirestore(doc.data()!, uid);
      } else {
        // New user - create document
        final userModel = UserModel(
          id: uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? googleUser.displayName ?? '',
          phone: '',
        );

        await _firestore.collection('users').doc(uid).set(userModel.toFirestore());

        print('✅ New Google user created: $uid');
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ FACEBOOK SIGN IN (Optional)
  // ========================================
  Future<UserModel> signinWithFacebook() async {
    // TODO: Implement Facebook Login
    // يتطلب إضافة flutter_facebook_auth package
    throw UnimplementedError('Facebook login not implemented yet');
  }

  // ========================================
  // ✅ SIGN OUT
  // ========================================
  Future<void> signOut() async {
    try {
      print('🔓 Signing out...');
      
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      print('✅ Signed out successfully');
    } catch (e) {
      print('❌ Sign out error: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ GET CURRENT USER
  // ========================================
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc.data()!, firebaseUser.uid);
    } catch (e) {
      print('❌ Error getting current user: $e');
      return null;
    }
  }

  // ========================================
  // 🛡️ HANDLE AUTH EXCEPTIONS
  // ========================================
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'network-request-failed':
        return 'خطأ في الاتصال بالإنترنت';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات، حاول لاحقاً';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموح بها';
      default:
        return 'حدث خطأ: ${e.message}';
    }
  }
}