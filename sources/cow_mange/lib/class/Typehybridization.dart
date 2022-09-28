class Typebridization {
  String? id_typebridization;
  String? name_typebridization;

  Typebridization({this.id_typebridization, this.name_typebridization});

  Map<String, dynamic> toJson() => {
        'id_typebridization': id_typebridization,
        'name_typebridization': name_typebridization,
      };

  Typebridization.nameTypebridization({this.name_typebridization});

  Typebridization.fromJson(Map<String, dynamic> json) {
    id_typebridization = json["id_Typehybridization"];
    name_typebridization = json["name_typehybridization"];
  }
}
