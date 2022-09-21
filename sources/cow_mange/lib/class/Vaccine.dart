class Vaccine {
  String? vaccine_id;
  String? name_vaccine;
  String? type_vaccine;
  String? properties;
  String? how_to_use;
  String? injection_program;

  Vaccine(
      {this.vaccine_id,
      this.name_vaccine,
      this.type_vaccine,
      this.properties,
      this.how_to_use,
      this.injection_program});

  Vaccine.fromJson(Map<String, dynamic> json) {
    vaccine_id = json['Vaccine_id'];
    name_vaccine = json['Name_vaccine'];
    type_vaccine = json['Type_vaccine'];
    properties = json['properties'];
    how_to_use = json['how_to_use'];
    injection_program = json['injection_program'];
  }

  Vaccine.IdVaccine({this.vaccine_id});
}
