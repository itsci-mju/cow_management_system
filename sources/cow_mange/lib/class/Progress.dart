import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Date.dart';

class Progress {
  String? id_progress;
  DateTime? progress_date;
  double? weight;
  double? height;
  Cow? cow;

  Progress(
      {this.id_progress,
      this.progress_date,
      this.weight,
      this.height,
      this.cow});

  Progress.fromJson(Map<String, dynamic> json) {
    id_progress = json["id_progress"];
    progress_date = Date.fromJson(json["Progress_date"]).toDateTime();
    weight = json["weight"];
    height = json["height"];
    cow = Cow.fromJson(json["cow"]);
  }
  Map<String, dynamic> tojson_Progress() {
    return <String, dynamic>{
      'progress_date': progress_date!.toIso8601String().split("T")[0],
      'weight': weight,
      'height': height,
      'cow': cow?.cow_id,
    };
  }
}
