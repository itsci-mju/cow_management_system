class Food {
  String? foodid;
  String? food_name;

  Food({this.foodid, this.food_name});

  Food.fromJson(Map<String, dynamic> json) {
    foodid = json["foodid"];
    food_name = json["food_name"];
  }

  Food.Idfood({this.foodid});
}
