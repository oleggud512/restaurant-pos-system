import 'dart:convert';
import 'package:dio/dio.dart';

import 'models.dart';

class Repo {
  final dio = Dio();
  final String ROOT = 'http://127.0.0.1:5000/restaurant/v1/';

  Future<List<Supplier>> getSuppliers() async {
    var responce = await dio.get("${ROOT}suppliers");
    var data = jsonDecode(responce.data);
    // return Future.delayed(const Duration(seconds: 1), () => data.map<Supplier>((e) => Supplier.fromJson(e)).toList());
    return data.map<Supplier>((e) => Supplier.fromJson(e)).toList(); 
  }

  Future<Supplier> getSupplier(int id) async {
    var responce = await dio.get('${ROOT}suppliers/$id');
    var data = jsonDecode(responce.data);
    // return Future.delayed(const Duration(seconds: 1), () => Supplier.fromJson(data[0]));
    return Supplier.fromJson(data[0]);
  }

  Future<String> updateSupplier(Supplier supplier) async {
    var data = supplier.toJson();
    var responce = await dio.put('${ROOT}suppliers/${supplier.supplierId}', data: data);
    // return Future.delayed(const Duration(seconds: 1), () =>'success');
    return responce.data;
  }

  Future<List<Grocery>> getGroceries({String like='', bool suppliedOnly=false}) async {
    var responce = await dio.get("${ROOT}groceries", queryParameters: {'like': like, 'supplied_only': suppliedOnly});
    var data = jsonDecode(responce.data);
    // return Future.delayed(const Duration(seconds: 1), () => data.map<Grocery>((e) => Grocery.fromJson(e)).toList());
    return data.map<Grocery>((e) => Grocery.fromJson(e)).toList();
  }

  Future<Grocery> getGrocery(int id) async {
    var responce = await dio.get("${ROOT}groceries/$id");
    var data = jsonDecode(responce.data);
    // return Future.delayed(const Duration(seconds: 1), () => Grocery.fromJson(data));
    return Grocery.fromJson(data);
  }

  Future<String> updateGrocery(Grocery groc) async {
    var responce = await dio.put(
      "${ROOT}groceries/${groc.grocId}",
      queryParameters: {
        'ava_count': groc.avaCount,
        'groc_name': groc.grocName,
        'groc_measure': groc.grocMeasure
      } 
    );
    // return Future.delayed(const Duration(seconds: 1), () => responce.data);
    return responce.data;
  }

  Future<String> addGrocery(MiniGroc groc) async {
    await dio.post(
      "${ROOT}groceries",
      data: {
        'ava_count': groc.avaCount,
        'groc_name': groc.grocName,
        'groc_measure': groc.grocMeasure
      }
    );
    return 'success';
  }

  Future<String> addSupplier(String name, String contacts) async {
    await dio.post(
      "${ROOT}suppliers",
      data: {
        'supplier_name': name,
        'contacts': contacts
      }
    );
    return 'success';
  }

  Future<String> deleteSupplier(int id) async {
    await dio.delete('${ROOT}suppliers/$id');
    return 'success';
  }

  Future<List<Supply>> getSupplys({FilterSortData? fsd}) async {
    print(fsd?.toJson());
    var responce = await dio.get('${ROOT}supplys', queryParameters: (fsd != null) ? fsd.toJson() : null);
    return Future.delayed(const Duration(seconds: 1), () => listSupplyFromJson(responce.data));
  }

  Future<String> addSupply(Supply supply) async {
    var responce = await dio.post('${ROOT}supplys', data: supply.toJson());
    return Future.delayed(const Duration(seconds: 1), () => responce.data);
  }

  Future<String> deleteSupply(int supplyId) async {
    var responce = await dio.delete('${ROOT}supplys/$supplyId');
    return Future.delayed(const Duration(seconds: 1), () => responce.data);
  }

  Future<FilterSortData> getFilterSortData() async {
    var responce = await dio.get('${ROOT}supplys/filter_sort');
    return Future.delayed(const Duration(seconds: 1), () => filterSortDataFromJson(responce.data));
  }

  Future<String> delInfoDelSuppliers() async {
    var responce = await dio.delete('${ROOT}suppliers/delete_info_about_deleted_suppliers');
    return Future.delayed(const Duration(seconds: 1), () => responce.data);
  }

  Future<Map<String, dynamic>> getDishes({FilterSortMenu? fsMenu}) async {
    var responce = await dio.get('${ROOT}menu', queryParameters: fsMenu?.toJson() ?? FilterSortMenu.init().toJson());
    Map<String, dynamic> data = jsonDecode(responce.data) as Map<String, dynamic>;
    List<Dish> dishes = List<Dish>.from(data['dishes'].map((e) => Dish.fromJson(e)));
    List<DishGroup> groups = List<DishGroup>.from(data['groups'].map((e) => DishGroup.fromJson(e)));
    
    return Future.delayed(const Duration(milliseconds: 500), () => {
      "dishes" : dishes,
      "groups" : groups
    });
  }

  Future<FilterSortMenu> getFilterSortMenu() async {
    var responce = await dio.get('${ROOT}menu/filter-sort');
    // return Future.delayed(const Duration(milliseconds: 500), () => FilterSortMenu.fromJson(jsonDecode(responce.data)));
    return FilterSortMenu.fromJson(jsonDecode(responce.data));
  }

  Future<String> addDish(Dish dish) async {
    var responce = await dio.post('${ROOT}menu', data: dish.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<dynamic> getPrimeCost(Dish dish) async { // вот это не работает правильно и на стороне python тоже
    var responce = await dio.get('${ROOT}menu/prime-cost/${dish.dishGrocs.map((e) => '${e.grocId}|${e.grocCount}').join('+')}'
    );
    // не преобразовую это в объект
    // передаю просто List<Map<String, dynamic>>
    // return Future.delayed(const Duration(milliseconds: 500), () => jsonDecode(responce.data));
    return jsonDecode(responce.data); 
  }

  Future<String> addDishGroup(String name) async {
    var responce = await dio.post('${ROOT}menu/add-dish-group', data: {'name': name});
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data; 
  }

  Future<String> updateDish(Dish dish) async {
    var responce = await dio.put('${ROOT}menu', data: dish.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data; 
  }

  String getImagePath({int imageId=0}) {
    return 'http://127.0.0.1:5000/static/images/$imageId.jpg';
  }

  Future<List<Role>> getRoles() async {
    var respocne = await dio.get('${ROOT}roles');
    // return Future.delayed(const Duration(milliseconds: 500), () => roleListFromJson(respocne.data));
    return roleListFromJson(respocne.data);
  }

  Future<String> addRole(Role role) async {
    var responce = await dio.post('${ROOT}roles', data: role.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<String> deleteRole(int roleId) async {
    var responce = await dio.delete('${ROOT}roles/$roleId');
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data); 
    return responce.data;
  }

  Future<String> updateRole(Role role) async {
    var responce = await dio.put('${ROOT}roles', data: role.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }


  Future<Map<String, dynamic>> getEmployees({FilterSortEmployeeData? fsEmp}) async {
    var responce = await dio.get('${ROOT}employees', queryParameters: fsEmp?.toJson());
    // print(responce.data);
    var data = jsonDecode(responce.data);
    // return Future.delayed(const Duration(milliseconds: 500), () => <String, dynamic>{
    //   'employees': List<Employee>.from(data['employees'].map((e) => Employee.fromJson(e))),
    //   'filter_sort_data': FilterSortEmployeeData.fromJson(data['filter_sort_data'])
    // });
    return <String, dynamic>{
      'employees': List<Employee>.from(data['employees'].map((e) => Employee.fromJson(e))),
      'filter_sort_data': FilterSortEmployeeData.fromJson(data['filter_sort_data'])
    };
  }

  Future<String> addEmployee(Employee emp) async {
    var responce = await dio.post('${ROOT}employees', data: emp.toJson());
    return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    // return responce.data;
  }

  Future<String> updateEmployee(Employee emp) async {
    var responce = await dio.put('${ROOT}employees', data: emp.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<Map<String, dynamic>> getRolesEmployees({FilterSortEmployeeData? fsEmp}) async {
    var responce = await dio.get('${ROOT}roles/employees', queryParameters: fsEmp?.toJson());
    // print(responce.data);
    var data = jsonDecode(responce.data) as Map<String, dynamic>;
    // return Future.delayed(const Duration(milliseconds: 500), () => <String, dynamic>{
    //   'employees': List<Employee>.from(data['employees'].map((e) => Employee.fromJson(e))),
    //   'filter_sort_data': FilterSortEmployeeData.fromJson(data['filter_sort_data']),
    //   'roles': List<Role>.from(data['roles'].map((e) => Role.fromJson(e))),
    //   'diary': List<Diary>.from(data['diary'].map((e) => Diary.fromJson(e)))
    // });
    return  {
      'employees': List<Employee>.from(data['employees'].map((e) => Employee.fromJson(e))),
      'filter_sort_data': FilterSortEmployeeData.fromJson(data['filter_sort_data']),
      'roles': List<Role>.from(data['roles'].map((e) => Role.fromJson(e))),
      'diary': List<Diary>.from(data['diary'].map((e) => Diary.fromJson(e)))
    };
  }

  Future<String> diaryStart(int empId) async {
    var responce = await dio.post('${ROOT}diary/start/$empId');
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<String> diaryGone(int empId) async {
    var responce = await dio.put('${ROOT}diary/gone/$empId');
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<List<Diary>> getDiary() async {
    var responce = await dio.get('${ROOT}diary');
    // return Future.delayed(const Duration(milliseconds: 500), () => diaryListFromJson(responce.data));
    return diaryListFromJson(responce.data);
  }

  Future<String> deleteDiary(int dId) async {
    var responce = await dio.delete('${ROOT}diary/$dId');
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }


  
  Future<List<Order>> getOrders() async {
    var responce = await dio.get('${ROOT}orders');
    // return Future.delayed(const Duration(milliseconds: 500), () => orderListFromJson(responce.data));
    return orderListFromJson(responce.data);
  }

  Future<String> addOrder(Order order) async {
    var responce = await dio.post('${ROOT}orders', data: order.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<String> deleteOrder(int ordId) async {
    var responce = await dio.delete('${ROOT}orders/$ordId');
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<String> payOrder(Order order) async {
    var responce = await dio.put('${ROOT}orders/pay', queryParameters: {
      'money_from_customer': order.moneyFromCustomer,
      'ord_id': order.ordId
    });
    // return Future.delayed(const Duration(milliseconds: 500), () => responce.data);
    return responce.data;
  }

  Future<Map<String, dynamic>> getStats({FilterSortStats? fsStats}) async {
    final response = await dio.get('${ROOT}stats', queryParameters: fsStats?.toJson());
    final data = response.data;
    // return Future.delayed(const Duration(milliseconds: 300), () => <String, dynamic>{
    //   'filter_sort_stats': FilterSortStats.fromJson(data['filter_sort_stats']),
    //   'stats_data': statsDataFromMap(data['stats_data'])
    // });
    return {
      'filter_sort_stats': FilterSortStats.fromJson(data['filtering_defaults']),
      'stats_data': statsDataFromMap(data['stats_data'])
    };
  }
}