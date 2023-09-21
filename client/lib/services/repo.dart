import 'dart:convert';
import 'dart:io';
import 'package:client/services/entities/diary.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/services/entities/employee.dart';
import 'package:client/services/entities/filter_sort_supplys_data.dart';
import 'package:client/services/entities/filter_sort_employee_data.dart';
import 'package:client/services/entities/filter_sort_menu_data.dart';
import 'package:client/services/entities/filter_sort_stats_data.dart';
import 'package:client/services/entities/grocery/grocery.dart';
import 'package:client/services/entities/grocery/mini_grocery.dart';
import 'package:client/services/entities/order.dart';
import 'package:client/services/entities/role.dart';
import 'package:client/services/entities/stats_data.dart';
import 'package:client/services/entities/supplier.dart';
import 'package:client/services/entities/supply.dart';
import 'package:dio/dio.dart';

import '../features/menu/domain/entities/prime_cost_data.dart';
import '../features/menu/domain/repositories/menu_repository.dart';
import 'entities/grocery/dish_grocery.dart';

const baseUrl = 'http://127.0.0.1:5000/restaurant/v1/';

class Repo implements MenuRepository {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl
  ));

  Future<List<Supplier>> getSuppliers() async {
    final response = await dio.get("suppliers");
    final data = jsonDecode(response.data);
    // return Future.delayed(const Duration(seconds: 1), () => data.map<Supplier>((e) => Supplier.fromJson(e)).toList());
    return data.map<Supplier>((e) => Supplier.fromJson(e)).toList(); 
  }

  Future<Supplier> getSupplier(int id) async {
    final response = await dio.get('suppliers/$id');
    final data = jsonDecode(response.data);
    // return Future.delayed(const Duration(seconds: 1), () => Supplier.fromJson(data[0]));
    return Supplier.fromJson(data[0]);
  }

  Future<String> updateSupplier(Supplier supplier) async {
    final data = supplier.toJson();
    final response = await dio.put('suppliers/${supplier.supplierId}', data: data);
    // return Future.delayed(const Duration(seconds: 1), () =>'success');
    return response.data;
  }

  Future<List<Grocery>> getGroceries({String like='', bool suppliedOnly=false}) async {
    final response = await dio.get("groceries", queryParameters: {'like': like, 'supplied_only': suppliedOnly});
    final data = jsonDecode(response.data);
    // return Future.delayed(const Duration(seconds: 1), () => data.map<Grocery>((e) => Grocery.fromJson(e)).toList());
    return data.map<Grocery>((e) => Grocery.fromJson(e)).toList();
  }

  Future<Grocery> getGrocery(int id) async {
    final response = await dio.get("groceries/$id");
    final data = jsonDecode(response.data);
    // return Future.delayed(const Duration(seconds: 1), () => Grocery.fromJson(data));
    return Grocery.fromJson(data);
  }

  Future<String> updateGrocery(Grocery groc) async {
    final response = await dio.put(
      "groceries/${groc.grocId}",
      queryParameters: {
        'ava_count': groc.avaCount,
        'groc_name': groc.grocName,
        'groc_measure': groc.grocMeasure
      } 
    );
    // return Future.delayed(const Duration(seconds: 1), () => response.data);
    return response.data;
  }

  Future<String> addGrocery(MiniGrocery groc) async {
    await dio.post(
      "groceries",
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
      "suppliers",
      data: {
        'supplier_name': name,
        'contacts': contacts
      }
    );
    return 'success';
  }

  Future<String> deleteSupplier(int id) async {
    await dio.delete('suppliers/$id');
    return 'success';
  }

  Future<List<Supply>> getSupplys({FilterSortSupplysData? fsd}) async {
    print(fsd?.toJson());
    final response = await dio.get('supplys', queryParameters: (fsd != null) ? fsd.toJson() : null);
    return Future.delayed(const Duration(seconds: 1), () => listSupplyFromJson(response.data));
  }

  Future<String> addSupply(Supply supply) async {
    final response = await dio.post('supplys', data: supply.toJson());
    return Future.delayed(const Duration(seconds: 1), () => response.data);
  }

  Future<String> deleteSupply(int supplyId) async {
    final response = await dio.delete('supplys/$supplyId');
    return Future.delayed(const Duration(seconds: 1), () => response.data);
  }

  Future<FilterSortSupplysData> getFilterSortData() async {
    final response = await dio.get('supplys/filter_sort');
    return Future.delayed(const Duration(seconds: 1), () => filterSortDataFromJson(response.data));
  }

  Future<String> delInfoDelSuppliers() async {
    final response = await dio.delete('suppliers/delete_info_about_deleted_suppliers');
    return Future.delayed(const Duration(seconds: 1), () => response.data);
  }

  /// returns an image url
  Future<String> addImage(File image) async {
    final res = await dio.post('image', data: FormData.fromMap({
      'image': MultipartFile.fromBytes(await image.readAsBytes())
    }));
    return res.data['image_url'];
  }

  @override
  Future<Dish> addDish(Dish dish, [File? photo]) async {
    final dishPhotoUrl = photo != null ? await addImage(photo) : '';
    print(dishPhotoUrl);
    if (dishPhotoUrl.isNotEmpty) {
      dish = dish.copyWith(dishPhotoUrl: dishPhotoUrl);
    }
    final response = await dio.post('menu', data: dish.toJson());
    print(response.data);
    return Dish.fromJson(response.data);
  }

  @override
  Future<Dish> updateDish(Dish dish, [File? photo]) async {
    final response = await dio.put('menu/${dish.dishId}', data: dish.toJson());
    return Dish.fromJson(response.data);
  }

  @override
  Future<PrimeCostData> getPrimeCost(List<DishGrocery> groceries) async {
    final qList = groceries
        .map((e) => '${e.grocId}|${e.grocCount}')
        .join('+');
    final response = await dio.get('menu/prime-cost/$qList');
    return PrimeCostData.fromJson(response.data);
  }

  @override
  Future<DishGroup> addDishGroup(String name) async {
    final response = await dio.post('menu/dish-groups', data: {'name': name});
    return DishGroup.fromJson(response.data);
  }

  @override
  Future<FilterSortMenuData> getFilterSortMenuData() async {
    final response = await dio.get('menu/filter-sort');
    return FilterSortMenuData.fromJson(response.data);
  }

  @override
  Future<Dish> getDish(int dishId) async {
    // TODO: use getDish in dishDetails and updateDish
    final response = await dio.get('menu/$dishId');
    return Dish.fromJson(response.data);
  }

  @override
  Future<List<Dish>> getDishes([FilterSortMenuData? filters]) async {
    final response = await dio.get('menu',
      queryParameters: filters?.toJson() ?? FilterSortMenuData().toJson()
    );
    return List<dynamic>.from(response.data)
      .map((d) => Dish.fromJson(d)).toList();
  }

  @override
  Future<List<DishGroup>> getAllDishGroups() async {
    final res = await dio.get('menu/dish-groups');
    return List<dynamic>
      .from(res.data)
      .map((gr) => DishGroup.fromJson(gr))
      .toList();
  }

  Future<List<Role>> getRoles() async {
    final respocne = await dio.get('roles');
    // return Future.delayed(const Duration(milliseconds: 500), () => roleListFromJson(respocne.data));
    return roleListFromJson(respocne.data);
  }

  Future<String> addRole(Role role) async {
    final response = await dio.post('roles', data: role.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    return response.data;
  }

  Future<String> deleteRole(int roleId) async {
    final response = await dio.delete('roles/$roleId');
    return response.data;
  }

  Future<String> updateRole(Role role) async {
    final response = await dio.put('roles', data: role.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    return response.data;
  }


  Future<Map<String, dynamic>> getEmployees({FilterSortEmployeeData? fsEmp}) async {
    final response = await dio.get('employees', queryParameters: fsEmp?.toJson());
    final emp = List.from(response.data['employees']).map((e) => Employee.fromJson(e)).toList();
    print(emp);
    return <String, dynamic>{
      'employees': emp,
      'filter_sort_data': FilterSortEmployeeData.fromJson(response.data['filter_sort_data'])
    };
  }

  Future<String> addEmployee(Employee emp) async {
    final response = await dio.post('employees', data: emp.toJson());
    return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    // return response.data;
  }

  Future<String> updateEmployee(Employee emp) async {
    final response = await dio.put('employees/${emp.empId}', data: emp.toJson());
    // return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    return response.data;
  }

  Future<Map<String, dynamic>> getRolesEmployees({FilterSortEmployeeData? fsEmp}) async {
    final response = await dio.get('roles/employees', queryParameters: fsEmp?.toJson());
    // print(response.data);
    final data = jsonDecode(response.data) as Map<String, dynamic>;
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
    final response = await dio.post('diary/start/$empId');
    // return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    return response.data;
  }

  Future<String> diaryGone(int empId) async {
    final response = await dio.put('diary/gone/$empId');
    return response.data;
  }

  Future<List<Diary>> getDiary() async {
    final response = await dio.get('diary');
    return List.from(response.data).map((d) => Diary.fromJson(d)).toList();
  }

  Future<String> deleteDiary(int dId) async {
    final response = await dio.delete('diary/$dId');
    // return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    return response.data;
  }
  
  Future<List<Order>> getOrders() async {
    final response = await dio.get('orders');
    return List.from(response.data).map((o) => Order.fromJson(o)).toList();
  }

  // returns newly created order id.
  Future<int> addOrder(Order order) async {
    final response = await dio.post('orders', data: order.toJson());
    return response.data['ord_id'];
  }

  Future<String> deleteOrder(int ordId) async {
    final response = await dio.delete('orders/$ordId');
    // return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    return response.data;
  }

  Future<String> payOrder(Order order) async {
    final response = await dio.put('orders/pay', queryParameters: {
      'money_from_customer': order.moneyFromCustomer,
      'ord_id': order.ordId
    });
    // return Future.delayed(const Duration(milliseconds: 500), () => response.data);
    return response.data;
  }

  Future<Map<String, dynamic>> getStats({FilterSortStatsData? fsStats}) async {
    final response = await dio.get('stats', queryParameters: fsStats?.toJson());
    final data = response.data;
    // return Future.delayed(const Duration(milliseconds: 300), () => <String, dynamic>{
    //   'filter_sort_stats': FilterSortStats.fromJson(data['filter_sort_stats']),
    //   'stats_data': statsDataFromMap(data['stats_data'])
    // });
    return {
      'filter_sort_stats': FilterSortStatsData.fromJson(data['filtering_defaults']),
      'stats_data': statsDataFromMap(data['stats_data'])
    };
  }
}