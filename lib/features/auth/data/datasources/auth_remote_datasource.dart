import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password, String displayName);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> updateUserData(UserModel user);
  Future<void> deleteUser(String userId);
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._auth, this._firestore, this._googleSignIn);

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await _getUserModel(result.user!);
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password, String displayName) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user!.updateDisplayName(displayName);
    final userModel = UserModel.fromFirebaseUser(result.user!, additionalData: {
      'displayName': displayName,
      'createdAt': DateTime.now().toIso8601String(),
    });
    await _firestore.collection(AppConstants.usersCollection).doc(userModel.id).set(userModel.toJson());
    return userModel;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign in cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    return await _getOrCreateUserModel(result.user!);
  }

  @override
  Future<UserModel> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    final result = await _auth.signInWithCredential(oauthCredential);
    return await _getOrCreateUserModel(result.user!);
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await _getUserModel(user);
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    await _firestore.collection(AppConstants.usersCollection).doc(user.id).update(user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestore.collection(AppConstants.usersCollection).doc(userId).delete();
    await _auth.currentUser?.delete();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _getUserModel(user);
    });
  }

  Future<UserModel> _getUserModel(firebase_auth.User firebaseUser) async {
    final doc = await _firestore.collection(AppConstants.usersCollection).doc(firebaseUser.uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  Future<UserModel> _getOrCreateUserModel(firebase_auth.User firebaseUser) async {
    final docRef = _firestore.collection(AppConstants.usersCollection).doc(firebaseUser.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    } else {
      final userModel = UserModel.fromFirebaseUser(firebaseUser, additionalData: {
        'createdAt': DateTime.now().toIso8601String(),
      });
      await docRef.set(userModel.toJson());
      return userModel;
    }
  }
}
