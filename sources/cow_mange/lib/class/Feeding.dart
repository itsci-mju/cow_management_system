import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Date.dart';
import 'package:cow_mange/class/food.dart';

class Feeding {
  String? id_Feeding;
  DateTime? record_date;
  double? amount;
  String? time;
  Cow? cow;
  Food? food;

  Feeding(
      {this.id_Feeding,
      this.record_date,
      this.time,
      this.amount,
      this.cow,
      this.food});

  Map<String, dynamic> tojson_Feeding() {
    return <String, dynamic>{
      'record_date': record_date!.toIso8601String(),
      'amount': amount,
      'time': time,
      'cow': cow?.cow_id,
      'food': food?.foodid,
    };
  }

  Feeding.fromJson(Map<String, dynamic> json) {
    id_Feeding = json["id_Feeding"];
    record_date = Date.fromJson(json["record_date"]).toDateTime();
    amount = json["amount"];
    time = json["time"];
    cow = Cow.fromJson(json["cow"]);
    food = Food.fromJson(json["food"]);
  }
}
