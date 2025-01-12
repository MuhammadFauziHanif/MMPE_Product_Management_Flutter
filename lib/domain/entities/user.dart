class User {
  String username;
  String password = '';
  String token;
  String role = '';

  User({required this.username, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'Username': String username,
        'Token': String token,
      } =>
        User(username: username, token: token),
      _ => throw const FormatException('Gagal membuat user')
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'username': this.username,
      'password': this.password,
      'token': this.token
    };
  }

  void info() {
    print('username: $username, token: $token');
  }
}
