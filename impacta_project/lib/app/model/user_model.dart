class UserModel {
  final String name;
  final String email;
  final String? birthday;

  UserModel({required this.name, required this.email, this.birthday});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      birthday: json['birthday'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'birthday': birthday};
  }

  @override
  String toString() {
    return 'UserModel{name: $name, email: $email, birthday: $birthday}';
  }
}
