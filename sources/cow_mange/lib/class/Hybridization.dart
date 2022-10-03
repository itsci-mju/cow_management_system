import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Date.dart';
import 'package:cow_mange/class/Typehybridization.dart';

class Hybridization {
  String? id_Hybridization;
  DateTime? date_Hybridization;
  DateTime? date_of_birthday;
  String? result;
  Typebridization? typebridization;
  Cow? bull_cow;
  Cow? cow_cow;

  Hybridization(
      {this.id_Hybridization,
      this.date_Hybridization,
      this.date_of_birthday,
      this.result,
      this.typebridization});

  Map<String, dynamic> tojson_Hybridization() {
    if (date_of_birthday == null) {
      return <String, dynamic>{
        'date_Hybridization':
            date_Hybridization!.toIso8601String().split("T")[0],
        'date_of_birthday': null,
        'result': result,
        'typebridization': typebridization?.name_typebridization,
        'bull_cow': bull_cow?.cow_id,
        'cow_cow': cow_cow?.cow_id,
      };
    } else {
      return <String, dynamic>{
        'date_Hybridization':
            date_Hybridization!.toIso8601String().split("T")[0],
        'date_of_birthday': date_of_birthday!.toIso8601String().split("T")[0],
        'result': result,
        'typebridization': typebridization?.name_typebridization,
        'bull_cow': bull_cow?.cow_id,
        'cow_cow': cow_cow?.cow_id,
      };
    }
  }

  Hybridization.fromJson(Map<String, dynamic> json) {
    result = json["result"];
    if (result == "สำเร็จ") {
      id_Hybridization = json["id_hybridization"];
      date_Hybridization =
          Date.fromJson(json["date_Hybirdzation"]).toDateTime();

      date_of_birthday = Date.fromJson(json["due_to_Brith"]).toDateTime();
      typebridization = Typebridization.fromJson(json["typehybridization"]);
    } else {
      id_Hybridization = json["id_hybridization"];
      date_Hybridization =
          Date.fromJson(json["date_Hybirdzation"]).toDateTime();
      date_of_birthday == null;
      typebridization = Typebridization.fromJson(json["typehybridization"]);
    }
  }
}
