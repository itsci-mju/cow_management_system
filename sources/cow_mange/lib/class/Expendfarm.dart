import 'package:cow_mange/class/Date.dart';
import 'package:cow_mange/class/ExpendType.dart';
import 'package:cow_mange/class/Farm.dart';

class Expendfarm {
  String? id_list;
  DateTime? expendFarmDate;
  String? name;
  int? amount;
  double? price;
  Farm? farm;
  ExpendType? expendType;

  Expendfarm(
      {this.id_list,
      this.expendFarmDate,
      this.name,
      this.amount,
      this.price,
      this.farm,
      this.expendType});

  Map<String, dynamic> toJsonExpendfarm() {
    return <String, dynamic>{
      'expendFarmDate': expendFarmDate?.toIso8601String().split("T")[0],
      'name': name,
      'amount': amount,
      'price': price,
      'farm': farm?.id_Farm,
      'expendType': expendType?.expendType_name,
    };
  }

  Map<String, dynamic> toJson_edit_Expendfarm() {
    return <String, dynamic>{
      'id_list': id_list,
      'expendFarmDate': expendFarmDate?.toIso8601String().split("T")[0],
      'name': name,
      'amount': amount,
      'price': price,
      'farm': farm?.id_Farm,
      'expendType': expendType?.expendType_name,
    };
  }

  factory Expendfarm.fromJson(Map<String, dynamic> json) => Expendfarm(
        id_list: json["id_list"],
        expendFarmDate: Date.fromJson(json["expendFarmDate"]).toDateTime(),
        name: json["name"],
        amount: json["amount"],
        price: json["price"],
        farm: Farm.fromJson(json["farm"]),
        expendType: ExpendType.fromJson(json["expendtype"]),
      );
}
