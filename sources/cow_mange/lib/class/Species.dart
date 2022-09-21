class Species {
  String? id_species;
  String? species_breed;
  String? country;

  Species({
    this.id_species,
    this.species_breed,
    this.country,
  });

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        id_species: json['id_species'],
        species_breed:
            json['species_breed'],
        country: json['country'],
      );

  factory Species.fromJson2(String json) => Species(
        species_breed: json,
      );

  Map<String, dynamic> toJson() => {
        'id_species': id_species,
        'species_breed': species_breed,
        'country': country,
      };

  Species.Newid_Species({this.id_species});

  Species.Newid_Specie2({
    this.id_species,
    this.species_breed,
    this.country,
  });
}
