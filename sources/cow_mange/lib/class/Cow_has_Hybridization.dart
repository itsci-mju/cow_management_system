import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Hybridization.dart';

class Cow_has_Hybridization {
  Cow? cow;
  Hybridization? hybridization;

  Cow_has_Hybridization(String string, {this.cow, this.hybridization});

  Cow_has_Hybridization.fromJson(Map<String, dynamic> json) {
    cow = Cow.fromJson(json["cow"]);
    hybridization = Hybridization.fromJson(json["hybridization"]);
  }

  Map<String, dynamic> toJson() => {
        "cow": cow!.tocow(),
        "Hybridization": hybridization!.tojson_Hybridization(),
      };
}
