import 'package:cow_mange/class/Farm.dart';

class Employee {
  String? username;
  String? password;
  String? firstname;
  String? lastname;
  String? email;
  String? tel;
  String? position;
  Farm? farm;

  Employee({
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.email,
    this.tel,
    this.position,
    this.farm,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        username: json["username"],
        password: json["password"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        tel: json["tel"],
        position: json["position"],
        farm: Farm.fromJson(json["farm"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "tel": tel,
        "position": position,
        "farm": farm?.id_Farm
      };

  Map<String, dynamic> toJsonLogin() => {
        "username": username,
        "password": password,
      };

  Map<String, dynamic> toJsoncow() => {"farm": farm!.id_Farm};
}
