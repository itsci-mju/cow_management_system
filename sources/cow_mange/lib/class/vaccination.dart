import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Date.dart';
import 'package:cow_mange/class/Vaccine.dart';

class Vaccination {
  DateTime? dateVaccination;
  int? countvaccine;
  String? doctorname;
  Cow? cow;
  Vaccine? vaccine;

  Vaccination(
      {this.dateVaccination,
      this.countvaccine,
      this.doctorname,
      this.cow,
      this.vaccine});
/*
  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      vaccine: Vaccine.fromJson(json["vaccine"]),
    );
  }*/

  Vaccination.fromJson(Map<String, dynamic> json) {
    dateVaccination = Date.fromJson(json["dateVaccination"]).toDateTime();
    countvaccine = json["countvaccine"];
    doctorname = json["namedocter"];
    vaccine = json["height"];
    cow = Cow.fromJson(json["cow"]);
    vaccine = Vaccine.fromJson(json["vaccine"]);
  }

  Map<String, dynamic> tojson_Vaccination() {
    return <String, dynamic>{
      'dateVaccination': dateVaccination!.toIso8601String().split("T")[0],
      'countvaccine': countvaccine,
      'doctorname': doctorname,
      'cow': cow?.cow_id,
      'vaccine': vaccine?.vaccine_id,
    };
  }
}
