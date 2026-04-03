import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._storageService);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _authService.currentUser != null && _user != null;
  String? get error => _error;
  String get uid => _authService.currentUser?.uid ?? '';

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<void> init() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      await _loadUser(firebaseUser.uid);
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      final uid = credential.user!.uid;
      _user = UserModel(
        uid: uid,
        displayName: displayName,
        email: email,
        photoUrl: credential.user?.photoURL,
      );
      await _firestoreService.createUser(_user!);
      await _storageService.saveUser(_user!);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _authErrorMessage(e.code);
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      await _loadUser(credential.user!.uid);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _authErrorMessage(e.code);
      _setLoading(false);
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _error = null;
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) {
        _setLoading(false);
        return false;
      }
      final firebaseUser = credential.user!;
      var existingUser = await _firestoreService.getUser(firebaseUser.uid);
      if (existingUser == null) {
        _user = UserModel(
          uid: firebaseUser.uid,
          displayName: firebaseUser.displayName ?? 'Explorer',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL,
        );
        await _firestoreService.createUser(_user!);
      } else {
        _user = existingUser;
      }
      await _storageService.saveUser(_user!);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Google sign-in failed. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordReset(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await _storageService.clearAll();
    _user = null;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    _user = user;
    await _firestoreService.updateUser(user);
    await _storageService.saveUser(user);
    notifyListeners();
  }

  Future<void> _loadUser(String uid) async {
    // Try local first, then remote
    _user = _storageService.getUser();
    if (_user == null || _user!.uid != uid) {
      _user = await _firestoreService.getUser(uid);
      if (_user != null) {
        await _storageService.saveUser(_user!);
      }
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _authErrorMessage(String code) => switch (code) {
        'email-already-in-use' => 'This email is already registered.',
        'invalid-email' => 'Invalid email address.',
        'weak-password' => 'Password must be at least 6 characters.',
        'user-not-found' => 'No account found with this email.',
        'wrong-password' => 'Incorrect password.',
        'user-disabled' => 'This account has been disabled.',
        _ => 'Authentication failed. Please try again.',
      };
}
