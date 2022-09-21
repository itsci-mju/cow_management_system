import 'package:cow_mange/class/Breeder.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Species.dart';

import 'Date.dart';

class Cow {
  String? cow_id;
  String? namecow;
  DateTime? birthday;
  String? gender;
  double? weight;
  double? height;
  String? picture;
  DateTime? registration_date;
  String? caretaker;
  String? status;
  String? color;
  Farm? farm;
  Species? species;
  Breeder? breeder;

  Cow(
      {this.cow_id,
      this.namecow,
      this.birthday,
      this.gender,
      this.weight,
      this.height,
      this.picture,
      this.registration_date,
      this.caretaker,
      this.status,
      this.color,
      this.farm,
      this.species,
      this.breeder});

  Cow.Idcow({this.cow_id});

  factory Cow.fromJson(Map<String, dynamic> json) => Cow(
        cow_id: json["cow_id"],
        namecow: json["namecow"],
        birthday: json["birthday"] == null
            ? null
            : Date.fromJson(json["birthday"]).toDateTime(),
        gender: json["gender"],
        weight: json["weight"],
        height: json["height"],
        picture: json["picture"],
        registration_date: json["registration_date"] == null
            ? null
            : Date.fromJson(json["registration_date"]).toDateTime(),
        caretaker: json["Caretaker"],
        status: json["status"],
        color: json["color"],
        farm: json["farm"] == null ? null : Farm.fromJson(json["farm"]),
        species:
            json["species"] == null ? null : Species.fromJson(json["species"]),
        breeder:
            json["breeder"] == null ? null : Breeder.fromJson(json["breeder"]),
      );

  Map<String, dynamic> tocow() {
    return <String, dynamic>{
      'cow_id': cow_id,
      'namecow': namecow,
      'birthday': birthday?.toIso8601String().split("T")[0],
      'gender': gender,
      'weight': weight,
      'height': height,
      'picture': picture,
      'registration_date': registration_date?.toIso8601String().split("T")[0],
      'caretaker': caretaker,
      'status': status,
      'color': color,
      'id_Farm': farm?.id_Farm,
      'id_Species': species?.id_species,
      'id_breeder': breeder?.idBreeder,
    };
  }

  Map<String, dynamic> tobreeder() => {
        'cow_id': cow_id,
      };

  Map<String, dynamic> tolistcow_edit() => {
        'cow_id': cow_id,
        'Farm_id_Farm': farm?.id_Farm,
      };
}
