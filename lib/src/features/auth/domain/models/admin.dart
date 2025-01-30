class Admin {
  final String id;
  final String email;
  final String password;

  Admin({
    required this.id,
    required this.email,
    required this.password,
  });

  // Convert Admin object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  // Convert Map to Admin object
  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
}
