class Admin {
  final String id;
  final String email;
  final String password;
  final bool isLoggedIn;

  Admin({
    required this.id,
    required this.email,
    required this.password,
    this.isLoggedIn = false,
  });

  // Convert Admin object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'is_logged_in': isLoggedIn ? 1 : 0,
    };
  }

  // Convert Map to Admin object
  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      isLoggedIn: map['is_logged_in'] == 1,
    );
  }
}
