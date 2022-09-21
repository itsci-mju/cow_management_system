
import 'package:cow_mange/class/Species.dart';

class Fitter {
  String? gendemale;
  String? genderwoman;
  List<Species>? species;
  String? startage;
  String? endage;
  String? idfarm;

  Fitter(
      {this.gendemale,
      this.genderwoman,
      this.species,
      this.startage,
      this.endage,
      this.idfarm});

  Map<String, dynamic> toJsonfitter() => {
        "gendemale": gendemale,
        "genderwoman": genderwoman,
        "species": species == null
            ? null
            : species!.map((item) => item.toJson()).toList(),
        "startage": startage,
        "endage": endage,
        "idfarm": idfarm,
      };
}
