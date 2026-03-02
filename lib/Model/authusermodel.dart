class AuthModel {
  String username;
  String password;

  AuthModel({this.username = '', this.password = ''});

  @override
  String toString() {
    return 'Username: $username, Password: $password';
  }
}
