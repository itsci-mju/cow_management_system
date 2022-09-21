class Farmtype {
  String? id_FarmType;
  String? name_FarmType;

  Farmtype({
    this.id_FarmType,
    this.name_FarmType,
  });

  factory Farmtype.fromJson(Map<String, dynamic> json) {
    return Farmtype(
      id_FarmType: json['id_FarmType'],
      name_FarmType: json['name_FarmType'],
    );
  }
}
