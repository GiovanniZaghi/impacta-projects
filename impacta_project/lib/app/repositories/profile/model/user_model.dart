class Users {
  int? id;
  String? name;
  String? email;
  String? password;
  String? birthday;

  Users({this.id, this.name, this.email, this.password, this.birthday});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    birthday = json['birthday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['birthday'] = this.birthday;
    return data;
  }
}
