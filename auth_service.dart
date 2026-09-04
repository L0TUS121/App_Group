import 'package:firebase_auth/firebase_auth.dart';

// Ця служба та відповідні екрани (screens/auth/*) не існували у
// вихідному main.dart — там home одразу вказував на MainPage. Оскільки
// структура проєкту явно передбачає auth_service.dart та screens/auth,
// нижче — стандартна обгортка над FirebaseAuth (email + пароль).
//
// Потребує пакета firebase_auth: `flutter pub add firebase_auth`.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageForCode(e.code));
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageForCode(e.code));
    }
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  String _messageForCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Некоректна електронна пошта';
      case 'user-disabled':
        return 'Обліковий запис заблоковано';
      case 'user-not-found':
        return 'Користувача не знайдено';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Невірний пароль';
      case 'email-already-in-use':
        return 'Ця пошта вже зареєстрована';
      case 'weak-password':
        return 'Пароль занадто простий';
      default:
        return 'Сталася помилка. Спробуйте ще раз';
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
