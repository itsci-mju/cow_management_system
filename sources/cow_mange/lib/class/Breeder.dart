class Breeder {
  String? idBreeder;
  String? father;
  String? mother;

  Breeder({this.idBreeder, this.father, this.mother});

  Breeder.fromJson(Map<String, dynamic> json) {
    idBreeder = json['id_breeder'];
    father = json['father'];
    mother = json['mother'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_breeder'] = idBreeder;
    data['father'] = father;
    data['mother'] = mother;
    return data;
  }

  Breeder.New_idBreeder({this.idBreeder});

  Map<String, dynamic> tobreeder_cow() => {
        'mother': mother,
      };
}
