import 'dart:convert';
import 'package:dio/dio.dart';

import 'models.dart';

class Repo {
  final dio = Dio();
  final String ROOT = 'http://127.0.0.1:5000/restaurant/v1/';

  Future<List<Supplier>> getSuppliers() async {
    var responce = await dio.get(ROOT + "suppliers");
    var data = jsonDecode(responce.data);
    return Future.delayed(const Duration(seconds: 1), () => data.map<Supplier>((e) => Supplier.fromJson(e)).toList());
    // return data.map<Supplier>((e) => Supplier.fromJson(e)).toList(); 
  }

  Future<Supplier> getSupplier(int id) async {
    var responce = await dio.get(ROOT + 'suppliers/' + id.toString());
    var data = jsonDecode(responce.data);
    return Future.delayed(const Duration(seconds: 1), () => Supplier.fromJson(data[0]));
  }

  Future<String> updateSupplier(Supplier supplier) async {
    var data = supplier.toJson();
    var responce = await dio.put(ROOT + 'suppliers/' + supplier.supplierId.toString(), data: data);
    return Future.delayed(const Duration(seconds: 1), () =>'success');
  }

  Future<List<Grocery>> getGroceries({String like=''}) async {
    var responce = await dio.get(ROOT + "groceries", queryParameters: {'like': like});
    var data = jsonDecode(responce.data);
    return Future.delayed(const Duration(seconds: 1), () => data.map<Grocery>((e) => Grocery.fromJson(e)).toList());
    // return data.map<Grocery>((e) => Grocery.fromJson(e)).toList();
  }

  Future<Grocery> getGrocery(int id) async {
    var responce = await dio.get(ROOT + "groceries/" + id.toString());
    var data = jsonDecode(responce.data);
    return Future.delayed(const Duration(seconds: 1), () => Grocery.fromJson(data));
  }

  Future<String> updateGrocery(Grocery groc) async {
    var responce = await dio.put(
      ROOT + "groceries/" + groc.grocId.toString(),
      queryParameters: {
        'ava_count': groc.avaCount,
        'groc_name': groc.grocName,
        'groc_measure': groc.grocMeasure
      } 
    );
    return Future.delayed(const Duration(seconds: 1), () => responce.data);
  }

  Future<String> addGrocery(MiniGroc groc) async {
    var responce = await dio.post(
      ROOT + "groceries",
      data: {
        'ava_count': groc.avaCount,
        'groc_name': groc.grocName,
        'groc_measure': groc.grocMeasure
      }
    );
    return 'success';
  }

  Future<String> addSupplier(String name, String contacts) async {
    var responce = await dio.post(
      ROOT + "suppliers",
      data: {
        'supplier_name': name,
        'contacts': contacts
      }
    );
    return 'success';
  }

  Future<String> deleteSupplier(int id) async {
    var responce = await dio.delete(ROOT + 'suppliers/' + id.toString());
    return 'success';
  }

  Future<List<Supply>> getSupplys({FilterSortData? fsd}) async {
    print(fsd?.toJson());
    var responce = await dio.get(ROOT + 'supplys', queryParameters: (fsd != null) ? fsd.toJson() : null);
    return Future.delayed(const Duration(seconds: 1), () => listSupplyFromJson(responce.data));
  }

  Future<String> addSupply(Supply supply) async {
    var responce = await dio.post(ROOT + 'supplys', data: supply.toJson());
    return Future.delayed(const Duration(seconds: 1), () => responce.data);
  }

  Future<String> deleteSupply(int supply_id) async {
    var responce = await dio.delete(ROOT + 'supplys/' + supply_id.toString());
    return Future.delayed(const Duration(seconds: 1), () => responce.data);
  }

  Future<FilterSortData> getFilterSortData() async {
    var responce = await dio.get(ROOT + 'supplys/filter_sort');
    return Future.delayed(const Duration(seconds: 1), () => filterSortDataFromJson(responce.data));
  }

  Future<String> delInfoDelSuppliers() async {
    var responce = await dio.delete(ROOT + 'settings/delete_info_about_deleted_suppliers');
    return Future.delayed(const Duration(seconds: 1), () => responce.data);
  }
}
/*
mport 'dart:convert';

import 'package:dio/dio.dart';
import 'classes.dart';
import 'dart:io';

class Services {
  static Dio dio = Dio();
  static String ROOT = 'http://127.0.0.1:5000/restaurant/v1/';

  static Future<Response> addGrocery({required String name, required String measure}) async {
    String path = ROOT + 'groceries';
    var res = await dio.post(path, data: {'name': name, 'measure': measure});
    return res;
  }

  static List<Supplier> _parseSuppliers(String data) {
    final parsed = jsonDecode(data);
    return parsed.map<Supplier>((e) => Supplier.fromJson(e)).toList();
  }

  static Future<List<Supplier>> getSuppliers() async {
    try {
      final res = await dio.get(ROOT + "suppliers");
      if (res.statusCode == 200) {
        List<Supplier> r = _parseSuppliers(res.data);
        return r;
      }
    }
    catch (e) {
      print("error in Services.getSuppliers() " + e.toString());
      return <Supplier>[];
    }
    return <Supplier>[];
  }

  static List<SupGrocery> _parseSupGrocery(String toParse) {
    final parsed = jsonDecode(toParse);
    return parsed.map<SupGrocery>((groc) => SupGrocery.fromJson(groc)).toList();
  }

  static Future<List<SupGrocery>> getAllGroceriesForSupplier(int supplier_id) async {
    try {
      final res = await dio.get(ROOT + "suppliers/groceries/"+supplier_id.toString());
      if (res.statusCode == 200) {
        List<SupGrocery> r = _parseSupGrocery(res.data);
        return r;
      }
    }
    catch (e) {
      print("error in Services.getAllGroceriesForSupplier() ||" + e.toString());
      return <SupGrocery>[];
    }
    return <SupGrocery>[];
  }



}
*/