class Admin {
  final String id;
  final String email;
  final String password;
  Admin({
    required this.id,
    required this.email,
    required this.password,
  });
   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      email: map['email'],
      password: map['password'],
    );
  }
 
}