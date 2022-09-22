import 'dart:convert';

import 'package:cow_mange/class/Cow.dart';
import 'package:cow_mange/class/Cow_has_Hybridization.dart';
import 'package:cow_mange/class/Employee.dart';
import 'package:cow_mange/class/ExpendType.dart';
import 'package:cow_mange/class/Expendfarm.dart';
import 'package:cow_mange/class/Farm.dart';
import 'package:cow_mange/class/Feeding.dart';
import 'package:cow_mange/class/Hybridization.dart';
import 'package:cow_mange/class/Progress.dart';
import 'package:cow_mange/class/Vaccine.dart';
import 'package:cow_mange/class/vaccination.dart';
import 'package:http/http.dart' as http;
import 'package:cow_mange/url/URL.dart';
import 'package:cow_mange/Drawer/Fitter.dart';

late List<dynamic> list;
Map? mapResponse;

class Breeder_data {
  Future fetch_Cow_cow(String cowId) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Getcow.toString()),
      body: jsonEncode({"cow_id": cowId}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      dynamic breeder = mapResponse!['result'];
      if (breeder == null) {
        return null;
      } else {
        return Cow.fromJson(breeder);
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future fetch_Cow_bull(String cowId) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Getcow.toString()),
      body: jsonEncode({"cow_id": cowId}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      dynamic breeder = mapResponse!['result'];
      if (breeder == null) {
        return null;
      } else {
        return Cow.fromJson(breeder);
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Fitter_data {
  Future fitterCow(Fitter ft) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Filter.toString()),
      body: jsonEncode(<String, String>{
        "fitter": jsonEncode(ft.toJsonfitter()),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];

      return list!.map((e) => Cow.fromJson(e)).toList();
    }
  }
}

class Cow_data {
  //List id
  List<String> listcow = [];
  List<String> listbull = [];
  Future listMaincow(Employee emp) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listmaincow),
      body: jsonEncode({"Farm_id_Farm": emp.farm!.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Cow.fromJson(e)).toList();
    }
  }

  Future listMaincow_farm(Farm farm) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listmaincow_farm),
      body: jsonEncode({"id_Farm": farm.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Cow.fromJson(e)).toList();
    }
  }

  Future fetchCow(t) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listbreedercow.toString()),
      body: jsonEncode({"Farm_id_Farm": t}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List? list;

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      mapResponse = json.decode(response.body);
      list = map['result'];
      listcow.add("----");
      for (dynamic l in list!) {
        listcow.add(l['cow_id']);
      }
      return listcow;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future fetchbull(idfarm) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listbreederbull.toString()),
      body: jsonEncode({"Farm_id_Farm": idfarm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    List? list;

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      mapResponse = json.decode(response.body);

      list = map['result'];
      listbull.add("----");
      for (dynamic l in list!) {
        listbull.add(l['cow_id']);
      }
      return listbull;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Progress_data {
  Future AddProgresscow(Progress progress) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_progress_add.toString()),
      body: jsonEncode(progress.tojson_Progress()),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic progress = mapResponse['result'];

      return Progress.fromJson(progress);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future listMainprogress(cowId) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_list_progress_id_cow.toString()),
      body: jsonEncode({
        "cow": cowId,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Progress.fromJson(e)).toList();
    }
  }

  Future DeleteProgress(idProgress) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_progress_delete.toString()),
      body: jsonEncode({
        "id_progress": idProgress,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic progress = mapResponse['result'];

      return progress;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Feeding_data {
  Future listMainFedding(cowId) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_list_feeding_id_cow.toString()),
      body: jsonEncode({
        "cow": cowId,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Feeding.fromJson(e)).toList();
    }
  }

  Future DeleteFedding(idFeeding) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_feeding_delete.toString()),
      body: jsonEncode({
        "id_Feeding": idFeeding,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic feeding = mapResponse['result'];

      return feeding;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Vaccination_data {
  Future listMainVaccination(cowId) async {
    final response = await http.post(
      Uri.parse(
          url.URL.toString() + url.URL_list_Vaccination_id_cow.toString()),
      body: jsonEncode({
        "cow": cowId,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Vaccination.fromJson(e)).toList();
    }
  }

  Future AddVaccinationcow(Vaccination vaccination) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Vaccination_add.toString()),
      body: jsonEncode(vaccination.tojson_Vaccination()),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200 && mapResponse['result'] == 0) {
      return 0;
    } else if (response.statusCode == 200) {
      dynamic vaccination = mapResponse['result'];
      return Vaccination.fromJson(vaccination);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future DeleteVaccination(dateVaccination) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Vaccination_delete.toString()),
      body: jsonEncode({
        "dateVaccination": dateVaccination,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic vaccination = mapResponse['result'];

      return vaccination;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Vaccine_data {
  Future listvaccine() async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listvaccine.toString()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      mapResponse = json.decode(response.body);
      list = map['result'];

      List<Vaccine> vaccination = list.map((i) => Vaccine.fromJson(i)).toList();

      return vaccination;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Hybridization_data {
  Future AddHybridization(Hybridization hybridization) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_hybridization_add.toString()),
      body: jsonEncode(hybridization.tojson_Hybridization()),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic progress = mapResponse['result'];

      return Hybridization.fromJson(progress);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future listMainCow_has_Hybridization(cowId) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() +
          url.URL_list_Cow_has_Hybridization_id_cow.toString()),
      body: jsonEncode({
        "cow": cowId,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Cow_has_Hybridization.fromJson(e)).toList();
    }
  }

  Future DeleteCow_has_Hybridization(cow, hybridization) async {
    final response = await http.post(
      Uri.parse(
          url.URL.toString() + url.URL_Cow_has_Hybridization_delete.toString()),
      body: jsonEncode({
        "cow": cow,
        "hybridization": hybridization,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic vaccination = mapResponse['result'];

      return vaccination;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Employee_data {
  Future List_employee(Farm farm) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_List_idfarm.toString()),
      body: jsonEncode({"id_Farm": farm.id_Farm}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      return list!.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future LoginEmployee(Employee employee) async {
    final JsonEmployeeLogin = employee.toJsonLogin();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Login.toString()),
      body: jsonEncode(JsonEmployeeLogin),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (response.statusCode == 200 && mapResponse['result'] == '0') {
      return 0;
    } else if (response.statusCode == 200 && mapResponse['result'] != '0') {
      dynamic emp = mapResponse['result'];

      return Employee.fromJson(emp);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future DeleteEmployee(username) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Employee_delete.toString()),
      body: jsonEncode({
        "username": username,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic employee = mapResponse['result'];

      return employee;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future RegisterEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_AddEmployee.toString()),
      body: jsonEncode(employee.toJson()),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic employee = mapResponse['result'];
      return Employee.fromJson(employee);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future EditEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_EditEmployee.toString()),
      body: jsonEncode(employee.toJson()),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic employee = mapResponse['result'];
      return Employee.fromJson(employee);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Farm_data {
  Future LoginFarm(Farm farm) async {
    final JsonFarmLogin = farm.toJsonLogin();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Login_farm.toString()),
      body: jsonEncode(JsonFarmLogin),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (response.statusCode == 200 && mapResponse['result'] == '0') {
      return 0;
    } else if (response.statusCode == 200 && mapResponse['result'] != '0') {
      dynamic farm = mapResponse['result'];

      return Farm.fromJson(farm);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future registerfarm(Farm farm) async {
    final JsonRegisterCow = farm.tofarm();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Addfarm.toString()),
      body: jsonEncode(JsonRegisterCow),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic farm = mapResponse['result'];

      return Farm.fromJson(farm);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future ListFarm() async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Listfarm.toString()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      String? stringResponse;
      List? list;
      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        mapResponse = json.decode(response.body);
        list = mapResponse['result'];
        return list!.map((e) => Farm.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load album');
      }
    }
  }
}

class Expend_data {
  Future AddExpend(Expendfarm expendfarm) async {
    final JsonaddExpend = expendfarm.toJsonExpendfarm();

    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_AddExpendfarm.toString()),
      body: jsonEncode(JsonaddExpend),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic expendfarm = mapResponse['result'];

      return Expendfarm.fromJson(expendfarm);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future EditExpendfarm(Expendfarm expendfarm) async {
    final JsonaddExpend = expendfarm.toJson_edit_Expendfarm();
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Edit_Expendfarm.toString()),
      body: jsonEncode(JsonaddExpend),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic expendfarm = mapResponse['result'];
      return Expendfarm.fromJson(expendfarm);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future ListExpend() async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_ListExpend.toString()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      String? stringResponse;
      List? list;
      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        mapResponse = json.decode(response.body);
        list = mapResponse['result'];
        return list!.map((e) => Expendfarm.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load album');
      }
    }
  }

  Future DeleteExpend(idExpend) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_Expend_delete.toString()),
      body: jsonEncode({
        "id_list": idExpend,
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic expendfarm = mapResponse['result'];

      return expendfarm;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class ExpendType_data {
  List<String> list_exp_name = [];
  Future listExpendType() async {
    final response = await http.post(
        Uri.parse(url.URL.toString() + url.URL_ListExpendTypem.toString()));

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      mapResponse = json.decode(response.body);
      list = mapResponse['result'];

      for (dynamic l in list!) {
        list_exp_name.add(l['ExpendType_name']);
      }
      return list_exp_name;
    }
  }

  Future Getexpendtype(String idExpendtype) async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_GetExpendTypem),
      body: jsonEncode({"idExpendType": idExpendtype}),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      dynamic expendType = mapResponse['result'];

      return ExpendType.fromJson(expendType);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class typehybridization_data {
  List<String> typeHybridization = [];
  Future list_typehybridization() async {
    final response = await http.post(
      Uri.parse(url.URL.toString() + url.URL_list_typehybridization.toString()),
    );

    String? stringResponse;
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      mapResponse = json.decode(response.body);

      list = map['result'];

      for (dynamic l in list!) {
        typeHybridization.add(l['name_typehybridization']);
      }

      return typeHybridization;
    }
  }
}
