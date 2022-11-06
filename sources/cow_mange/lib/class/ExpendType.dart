class ExpendType {
  String? idExpendType;
  String? expendType_name;

  ExpendType({this.idExpendType, this.expendType_name});

  Map<String, dynamic> toJsonExpendType() {
    return <String, dynamic>{
      'expendType_name': expendType_name,
    };
  }

  ExpendType.fromJson(Map<String, dynamic> json) {
    idExpendType = json['idExpendType'];
    expendType_name = json['ExpendType_name'];
  }

  ExpendType.expendType_name({this.expendType_name});
}
