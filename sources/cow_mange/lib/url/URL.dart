class url {
  static const String URL = "http://172.16.1.39:8081/project_cowmanage";

//employee
  static const String URL_Login = "/employee/login";

  static const String URL_List_idfarm = "/employee/listemployee_id_emp";

  static const String URL_Employee_delete = "/employee/delete";

  static const String URL_AddEmployee = "/employee/add";

  static const String URL_EditEmployee = "/employee/edit";
//cow
  static const String URL_Addcow = "/cow/add";

  static const String URL_Editcow = "/cow/edit";

  static const String URL_Getcow = "/cow/getcow";

  static const String URL_Listmaincow = "/cow/listmaincow";

  static const String URL_Listbreedercow = "/cow/listbreedercow";

  static const String URL_Listbreederbull = "/cow/listbreederbull";

  static const String URL_ListAllcow = "/cow/list";

  static const String URL_edit_Listbreederbull = "/cow/edit_listbreederbull";

  static const String URL_Get_breeder_Cow_cow = "/cow/Get_breeder_Cow_cow";

  static const String URL_Listmaincow_farm = "/cow/listmaincow_farm";

//species
  static const String URL_queryspecies = "/species/queryspecies";

  static const String URL_Listspecies = "/species/list";

//breeder
  static const String URL_querybreeder_and_Addbreeder = "/breeder/Add_and_list";

  //filter
  static const String URL_Filter = "/cow/listcowfitter";

//progress
  static const String URL_progress_add = "/progress/add";

  static const String URL_list_progress = "/progress_cow/list";

  static const String URL_list_progress_id_cow = "/progress_cow/list_id_cow";

  static const String URL_list_progress_id_cow_DESC =
      "/progress_cow/list_id_cow_DESC";

  static const String URL_progress_delete = "/progress/delete";

//food
  static const String URL_list_food = "/food/list";

//feeding
  static const String URL_feeding_add = "/feeding/add";

  static const String URL_list_feeding_id_cow = "/feeding/list_id_cow";

  static const String URL_list_feeding_id_cow_DESC =
      "/feeding/list_id_cow_DESC";

  static const String URL_feeding_delete = "/feeding/delete";

//Vaccination
  static const String URL_Listvaccination = "/Vaccination/list";

  static const String URL_Vaccination_add = "/Vaccination/add";

  static const String URL_list_Vaccination_id_cow = "/Vaccination/list_id_cow";

  static const String URL_Vaccination_delete = "/Vaccination/delete";

//vaccine
  static const String URL_Listvaccine = "/vaccine/list";

//typehybridization
  static const String URL_list_typehybridization = "/Typehybridization/list";

//hybridization
  static const String URL_hybridization_add = "/Hybridization/add";

//Cow_has_Hybridization
  static const String URL_list_Cow_has_Hybridization_id_cow =
      "/Cow_has_Hybridization/list_id_cow";

  static const String URL_Cow_has_Hybridization_delete =
      "/Cow_has_Hybridization/delete";

//farm
  static const String URL_Login_farm = "/farm/login";

  static const String URL_Addfarm = "/farm/add";

  static const String URL_Listfarm = "/farm/list";

//ExpendFarm
  static const String URL_AddExpendfarm = "/ExpendFarm/add";

  static const String URL_ListExpend = "/Expendfarm/list";

  static const String URL_Expend_delete = "/ExpendFarm/delete";

  static const String URL_Edit_Expendfarm = "/ExpendFarm/edit";

  static const String URL_List_idfarm_Expendfarm =
      "/ExpendFarm/listExpendfarm_idfarm";

//ExpendType
  static const String URL_ListExpendTypem = "/Expendtype/list";

  static const String URL_GetExpendTypem = "/Expendtype/getExpendtype";
}
