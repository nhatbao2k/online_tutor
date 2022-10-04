class Person{
  String? fullname;
  String? phone;
  String? email;
  String? birthday;
  String? address;
  String? avatar;
  String? describe;
  String? role;
  String? office;

  Person(
      {this.fullname,
      this.phone,
      this.email,
      this.birthday,
      this.address,
      this.avatar,
      this.describe,
      this.role,
      this.office});

  Person.fromJson(dynamic json) {
    phone = json['phone'];
    avatar = json['avatar'];
    fullname = json['fullname'];
    role = json['role'];
    email = json['email'];
    address = json['address'];
    birthday = json['birthday'];
    describe = json['describe'];
    office = json['office'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = phone;
    map['avatar'] = avatar;
    map['fullname'] = fullname;
    map['role'] = role;
    map['email'] = email;
    map['address'] = address;
    map['birthday'] = birthday;
    map['describe'] = describe;
    map['office'] = office;
    return map;
  }
}