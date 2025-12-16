import '../models/user.dart';

class AuthService {
  static final List<User> _users = [];

  // Simple register function
  static bool register(User user) {
    if (_users.any((u) => u.email == user.email)) {
      return false; // email already exists
    }
    _users.add(user);
    return true;
  }

  // Simple login function
  static User? login(String email, String password) {
    try {
      return _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  static List<User> get users => [..._users];
}
