import 'package:cow_mange/class/Farmtype.dart';

class Farm {
  String? id_Farm;
  String? name_Farm;
  String? addressFarm;
  String? photo;
  String? tel;
  String? certified_Farm;
  String? username;
  String? password;
  String? owner_name;
  String? email;
  Farmtype? farmtype;

  Farm({
    this.id_Farm,
    this.name_Farm,
    this.addressFarm,
    this.photo,
    this.tel,
    //this.certified_Farm,
    this.username,
    this.password,
    this.owner_name,
    this.email,
    this.farmtype,
  });

  Farm.Newid_farm({this.id_Farm});

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id_Farm: json['id_Farm'],
      name_Farm: json['name_Farm'],
      addressFarm: json['addressFarm'],
      tel: json['tel'],
      photo: json['photo'],
      username: json['username'],
      password: json['password'],
      //certified_Farm: json['certified_Farm'],
      owner_name: json['owner_name'],
      email: json['email'],
      farmtype: Farmtype.fromJson(json['farmType']),
    );
  }
  Map<String, dynamic> toJsonLogin() => {
        "username": username,
        "password": password,
      };

  Map<String, dynamic> tofarm() {
    return <String, dynamic>{
      'id_Farm': id_Farm,
      'name_Farm': name_Farm,
      'addressFarm': addressFarm,
      'photo': photo,
      'tel': tel,
      'username': username,
      'password': password,
      'owner_name': owner_name,
      'email': email,
      'farmtype': farmtype?.name_FarmType,
    };
  }
}
