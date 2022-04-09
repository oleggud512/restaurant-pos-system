import 'dart:convert';

import 'dart:io';

import 'package:client/employees/filter_sort_employee/filter_sort_employee.dart';
import 'package:flutter/material.dart';

enum View { list, grid }
enum Sorting { asc, desc }

class Supplier {
    Supplier({
        required this.supplierId,
        required this.supplierName,
        required this.contacts,
        required this.groceries,
        this.supGrocPrice
    });

    int supplierId;
    String supplierName;
    String? contacts;
    List<Grocery>? groceries;
    double? supGrocPrice; // для таблицы в GroceryDialog

    factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        supplierId: json["supplier_id"],
        supplierName: json["supplier_name"],
        contacts: json["contacts"],
        groceries: (json['groceries'] != null) ? List<Grocery>.from(json["groceries"].map((x) => Grocery.fromJson(x))) : null,
        supGrocPrice: json["sup_groc_price"],
    );

    Map<String, dynamic> toJson() => {
        "supplier_id": supplierId,
        "supplier_name": supplierName,
        "contacts": contacts,
        "groceries": List<dynamic>.from(groceries!.map((x) => x.toJson())), // если мы решимся что-то 
                                          // отправить, то это что-то точно будет с ингредиентами
                                          // даже если пустыми...
    };
}

class Grocery {

    Grocery({
        required this.supplierId,
        required this.grocId,
        required this.grocName,
        required this.supGrocPrice,
        required this.grocMeasure,
        required this.avaCount,
        required this.suppliedBy,
    });

    int? supplierId; // GroceriesCard doesn't need this
    int grocId;
    String grocName;
    double? supGrocPrice; // GroceriesCard doesn't need this
    String grocMeasure;
    double avaCount;
    List<Supplier> suppliedBy;
    bool selected = false;

    factory Grocery.fromJson(Map<String, dynamic> json) => Grocery(
        supplierId: json["supplier_id"],
        grocId: json["groc_id"],
        grocName: json["groc_name"],
        supGrocPrice: json["sup_groc_price"],
        grocMeasure: json["groc_measure"],
        avaCount: json["ava_count"],
        suppliedBy: json["supplied_by"].map<Supplier>((e) => Supplier.fromJson(e)).toList(),
    );

    Map<String, dynamic> toJson() => {
        "supplier_id": supplierId,
        "groc_id": grocId,
        "groc_name": grocName,
        "sup_groc_price": supGrocPrice,
        "groc_measure": grocMeasure,
        "ava_count": avaCount,
        // "supplied_by": suppliedBy,
    };
}

class MiniGroc {
  double? supGrocPrice;
  int? grocId;
  String grocName;
  String grocMeasure;
  int avaCount;

  MiniGroc({
    required this.grocName,
    required this.grocMeasure,
    required this.avaCount
  });

  factory MiniGroc.empty() => MiniGroc(
    avaCount: 0,
    grocMeasure: 'gram',
    grocName: ''
  );

  Map<String, dynamic> toJson() => {
    "groc_name" : grocName,
    "groc_measure" : grocMeasure,
    "ava_count" : avaCount,
    if (grocId != null) "groc_id": grocId,
    if (supGrocPrice != null) "sup_groc_price": supGrocPrice
  };
}


Supply supplyFromJson(String str) => Supply.fromJson(json.decode(str));

List<Supply> listSupplyFromJson(String str){ return List<Supply>.from(jsonDecode(str).map((x) => Supply.fromJson(x)));}

String supplyToJson(Supply data) => json.encode(data.toJson());

String dateToString(DateTime date) => "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

class Supply {
    Supply({
        required this.supplyId,
        required this.summ,
        required this.supplierId,
        required this.supplierName,
        required this.supplyDate,
        required this.groceries,
    });

    int? supplyId; // это будет null при добавлении новой поставки
    double summ;
    int? supplierId; // по вот этому будет проверяться можем ли мы добавить поставку или нет
    String supplierName;
    DateTime supplyDate;
    List<SupplyGrocery> groceries; // по этому тоже проверяем на 
    
    factory Supply.fromJson(Map<String, dynamic> json) => Supply(
        supplyId: json["supply_id"],
        summ: json["summ"],
        supplierId: json["supplier_id"],
        supplierName: json["supplier_name"],
        supplyDate: DateTime.parse(json["supply_date"]),
        groceries: List<SupplyGrocery>.from(json["groceries"].map((x) => SupplyGrocery.fromJson(x))),
    );

    factory Supply.empty() => Supply(
      summ: 0,
      supplierName: '',
      supplyDate: DateTime.now(),
      groceries: [],
      supplierId: null,
      supplyId: null,
    );

    Map<String, dynamic> toJson() => {
        "summ": summ,
        "supplier_id": supplierId,
        "supply_date": "${supplyDate.year.toString().padLeft(4, '0')}-${supplyDate.month.toString().padLeft(2, '0')}-${supplyDate.day.toString().padLeft(2, '0')}",
        "groceries": List<dynamic>.from(groceries.map((x) => x.toJson())),
    };
}


class SupplyGrocery {
    SupplyGrocery({
        required this.grocId,
        required this.grocName,
        required this.grocCount,
        required this.supGrocPrice
    });

    int? grocId;
    String? grocName;
    double? grocCount;
    double? supGrocPrice;


    factory SupplyGrocery.empty() => SupplyGrocery(
      grocId: null,
      grocName: null,
      grocCount: 0,
      supGrocPrice: 0
    );

    factory SupplyGrocery.fromJson(Map<String, dynamic> json) {
      return SupplyGrocery(
          supGrocPrice: json["groc_price"],
          grocId: json["groc_id"],
          grocName: json["groc_name"],
          grocCount: json["groc_count"].toDouble(),
      );
    }

    Map<String, dynamic> toJson() => {
        "groc_id": grocId,
        "groc_count": grocCount!.toInt(),
    };
}



///////////////////////////////////////////////////////////////////////////////
////////////////////////////FilterSortData/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


FilterSortData filterSortDataFromJson(String str) => FilterSortData.fromJson(jsonDecode(str));

String filterSortDataToJson(FilterSortData data) => jsonEncode(data.toJson());

class FilterSortData {
    FilterSortData({
        required this.maxDate,
        required this.minDate,
        required this.maxPrice,
        required this.suppliers,
    }) : fPriceTo = maxPrice,
         fDateFrom = minDate,
         fDateTo = maxDate;

    DateTime minDate;
    DateTime maxDate;
    double maxPrice;
    List<MiniSupplier> suppliers;

    String sortCollumn = 'supply_date';
    String sortDirection = 'desc';
    double fPriceFrom = 0.0;
    double fPriceTo;
    DateTime fDateFrom;
    DateTime fDateTo;

    // String get sortCollumn => _sortCollumn;
    // set sortCollumn(String newVal) => sortCollumn = newVal;

    factory FilterSortData.fromJson(Map<String, dynamic> json) => FilterSortData(
        maxDate: DateTime.parse(json["max_date"]),
        minDate: DateTime.parse(json["min_date"]),
        maxPrice: json["max_summ"].toDouble(),
        suppliers: List<MiniSupplier>.from(json["suppliers"].map((x) => MiniSupplier.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
      'sort_collumn' : sortCollumn,
      'sort_direction' : sortDirection,
      'price_from' : fPriceFrom,
      'price_to' : fPriceTo,
      'date_from' : fDateFrom,
      'date_to' : fDateTo,
      'suppliers' : List<int>.from(suppliers
        .where((element) => element.selected == true)
        .map((e) => e.supplierId))
        .join('+')
    };
}

class MiniSupplier {
    MiniSupplier({
        required this.supplierName,
        required this.supplierId,
    });

    String supplierName;
    int supplierId;
    bool selected = true;

    factory MiniSupplier.fromJson(Map<String, dynamic> json) => MiniSupplier(
        supplierName: json["supplier_name"],
        supplierId: json["supplier_id"],
    );

    Map<String, dynamic> toJson() => {
        "supplier_name": supplierName,
        "supplier_id": supplierId,
    };
}

class FilterSoort{
  String? sortCollumn;
  String? sortDirection;

  double? fPriceFrom;
  double? fPriceTo;

  DateTime? fDateFrom;
  DateTime? fDateTo;

  Map<String, dynamic> toJson() => {
    'sorting' : {
      'collumn' : sortCollumn ?? 'supply_date',
      'direction' : sortDirection ?? 'desc'
    },
    'filter' : {
      'price' : {
        'from' : fPriceFrom ?? 0,
        'to' : fPriceTo 
      }
    }
  };

  
}

///////////////////////////////////////////////////////////////////////////////
//////////////////////////////===// DISHES //===///////////////////////////////
///////////////////////////////////////////////////////////////////////////////

List<Dish> listDishFromJson(String str) => List<Dish>.from(json.decode(str).map((x) => Dish.fromJson(x)));

String listDishToJson(List<Dish> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dish {
    Dish({
        required this.dishId,
        required this.dishName,
        required this.dishPrice,
        required this.dishGrId,
        required this.dishGrocs, 
        required this.dishPhotoIndex,
        required this.dishDescr,
    });

    int? dishId;
    String dishName;
    double? dishPrice;
    int dishGrId;
    List<DishGroc> dishGrocs;
    int dishPhotoIndex;
    String dishDescr;
    File? photo;

    factory Dish.initial() => Dish(
      dishId: null,
      dishName: '',
      dishPrice: null,
      dishGrId: 1, // unsorted
      dishPhotoIndex: 0,
      dishDescr: '',
      dishGrocs: []
    );

    factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        dishId: json["dish_id"],
        dishName: json["dish_name"],
        dishPrice: json["dish_price"].toDouble(),
        dishGrId: json["dish_gr_id"],
        dishPhotoIndex: json['dish_photo_index'],
        dishDescr: json['dish_descr'],
        dishGrocs: List<DishGroc>.from(json["consist"]?.map((x) => DishGroc.fromJson(x)) ?? []),
    );

    factory Dish.copy(Dish other) => Dish(
      dishId: other.dishId,
      dishName: other.dishName,
      dishPrice: other.dishPrice,
      dishGrId: other.dishGrId,
      dishPhotoIndex: other.dishPhotoIndex,
      dishDescr: other.dishDescr,
      dishGrocs: List.from(other.dishGrocs)
    );

    Map<String, dynamic> toJson() => {
        "dish_id": dishId,
        "dish_name": dishName,
        "dish_price": dishPrice,
        "dish_gr_id": dishGrId,
        "dish_photo_index" : dishPhotoIndex,
        "consist": List<dynamic>.from(dishGrocs.map((x) => x.toJson())),
        "photo": (photo != null) ? base64Encode(photo!.readAsBytesSync()) : null,
        "dish_descr": dishDescr,
    };

    bool get isSaveable => dishPrice != 0 
      && dishName.isNotEmpty 
      && !dishGrocs.map<double>((e) => e.grocCount).contains(0) 
      && dishGrocs.isNotEmpty;
}

class DishGroc {
    DishGroc({
        required this.grocId,
        required this.grocName,
        required this.grocCount,
    });

    int grocId;
    String grocName;
    double grocCount;

    @override
    String toString() {
      return toJson().toString();
    }

    factory DishGroc.initial(int grocId, String grocName) => DishGroc(
      grocCount: 0,
      grocId: grocId,
      grocName: grocName,
    );

    factory DishGroc.fromJson(Map<String, dynamic> json) => DishGroc(
        grocId: json["groc_id"],
        grocName: json["groc_name"],
        grocCount: json["dc_count"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "groc_id": grocId,
        "groc_name": grocName,
        "groc_count": grocCount,
    };
}

List<DishGroup> groupFromJson(String str) => List<DishGroup>.from(json.decode(str).map((x) => DishGroup.fromJson(x)));

String groupToJson(List<DishGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DishGroup {

    DishGroup({
        required this.groupId,
        required this.groupName,
    });

    int groupId;
    String groupName;
    bool selected = false;

    factory DishGroup.fromJson(Map<String, dynamic> json) => DishGroup(
        groupId: json["dish_gr_id"],
        groupName: json["dish_gr_name"],
    );

    Map<String, dynamic> toJson() => {
        "dish_gr_id": groupId,
        "dish_gr_name": groupName,
    };
}


class FilterSortMenu {
  String asc = 'desc';
  String sortColumn = 'dish_name'; // 'dish_price'
  String like = '';
  List<Grocery> groceries = [];
  List<DishGroup> groups = [];
  double? priceFrom;
  double? priceTo;

  FilterSortMenu({
    // required this.groceries,
    required this.priceFrom,
    required this.priceTo
  });

  factory FilterSortMenu.fromJson(Map m) => FilterSortMenu(
    // groceries: [],
    priceFrom: m['min_price'],
    priceTo: m['max_price']
  );

  factory FilterSortMenu.init() => FilterSortMenu(
    priceFrom: null,
    priceTo: null
  );

  Map<String, dynamic> toJson() => {
      "asc" : asc,
      "sort_column" : sortColumn,
      "like" : like,
      "price_from" : priceFrom,
      "price_to" : priceTo,
      "groceries" : List<int>.from(groceries.map((e) => e.grocId)).join('+'),
      "groups" : List<int>.from(groups.map((e) => e.groupId)).join('+'),
  };
}



////////////////////////////////////////////////////////////////////////////



List<Role> roleListFromJson(String str) => List<Role>.from(json.decode(str).map((x) => Role.fromJson(x)));

String roleToJson(List<Role> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Role {

    Role({
        required this.roleId,
        required this.roleName,
        required this.salaryPerHour,
    });

    int? roleId;
    String roleName;
    double salaryPerHour;
    bool selected = false;

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleId: json["role_id"],
        roleName: json["role_name"],
        salaryPerHour: json["salary_per_hour"].toDouble(),
    );

    factory Role.init() => Role(
      roleId: null,
      roleName: '',
      salaryPerHour: 0.0
    );

    Map<String, dynamic> toJson() => {
        "role_id": roleId,
        "role_name": roleName,
        "salary_per_hour": salaryPerHour,
    };

    bool get saveable => salaryPerHour > 0.0 && roleName.isNotEmpty;

}



List<Employee> employeeListFromJson(String str) => List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
    Employee({
        required this.empId,
        required this.roleId,
        required this.isWaiter,
        required this.empFname,
        required this.empLname,
        required this.birthday,
        required this.phone,
        required this.email,
        required this.gender,
        required this.hoursPerMonth,
    });

    int? empId;
    int roleId;
    bool isWaiter;
    String empFname;
    String empLname;
    DateTime birthday;
    String phone;
    String email;
    String gender;
    int hoursPerMonth;

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        empId: json['emp_id'],
        roleId: json["role_id"],
        isWaiter: json['is_waiter'] == 1 ? true : false,
        empFname: json["emp_fname"],
        empLname: json["emp_lname"],
        birthday: DateTime.parse(json["birthday"]),
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        hoursPerMonth: json["hours_per_month"],
    );

    factory Employee.init() => Employee(
        empId: null,
        roleId: 0,
        isWaiter: false,
        empFname: '',
        empLname: '',
        birthday: DateTime.parse('2000-01-01'),
        phone: '',
        email: '',
        gender: 'm',
        hoursPerMonth: 0,
    );

    Map<String, dynamic> toJson() => {
        "emp_id": empId,
        "is_waiter": isWaiter ? 1 : 0,
        "role_id": roleId,
        "emp_fname": empFname,
        "emp_lname": empLname,
        "birthday": "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "phone": phone,
        "email": email,
        "gender": gender,
        "hours_per_month": hoursPerMonth,
    };

    bool get saveable => roleId != 0 && empFname.isNotEmpty && empLname.isNotEmpty;
}

List<Diary> diaryListFromJson(String str) => List<Diary>.from(json.decode(str).map((x) => Diary.fromJson(x)));

String diaryToJson(List<Diary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Diary {
    Diary({
        required this.dId,
        required this.date,
        required this.empId,
        required this.startTime,
        required this.endTime,
        required this.gone,
        required this.empName
    });

    int dId;
    DateTime date;
    int empId;
    String startTime;
    String endTime;
    bool gone;
    String empName;

    factory Diary.fromJson(Map<String, dynamic> json) => Diary(
        dId: json["d_id"],
        date: DateTime.parse(json["date_"]),
        empId: json["emp_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        gone: json["gone"] == 1 ? true : false,
        empName: json['emp_name']
    );

    Map<String, dynamic> toJson() => {
        "d_id": dId,
        "date_": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "emp_id": empId,
        "start_time": startTime,
        "end_time": endTime,
        "gone": gone,
    };
}




class OrderNode {
  Dish dish;
  int count;
  double price;

  OrderNode({
    required this.dish,
    required this.count,
    required this.price
  });

  factory OrderNode.toAdd(Dish dish, int count) => OrderNode(
    count: count,
    dish: dish,
    price: count * dish.dishPrice!
  );

  factory OrderNode.fromJson(Map<String, dynamic> json) => OrderNode(
    dish: Dish.fromJson(json['dish']),
    count: json['lord_count'],
    price: json['lord_price']
  );

  Map<String, dynamic> toJson() {
    return {
      "dish_id": dish.dishId,
      "count": count,
      "price": price
    };
  }

  void incr() {
    count += 1;
    price += dish.dishPrice!;
  }

  void decr() {
    count -= 1;
    price -= dish.dishPrice!;
  }

}

List<Order> orderListFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    Order({
        required this.ordId,
        required this.ordDate,
        required this.ordStartTime,
        required this.ordEndTime,
        required this.moneyFromCustomer,
        required this.totalPrice,
        required this.empId,
        this.empName,
        required this.comm,
        required this.isEnd,
        required this.listOrders
    });
    int? ordId;
    DateTime ordDate;
    DateTime ordStartTime;
    DateTime ordEndTime;
    double moneyFromCustomer;
    double totalPrice;
    int empId;
    String? empName;
    String comm;
    bool isEnd;
    List<OrderNode> listOrders;

    factory Order.init(int emp_id) {
      return Order(
        ordId: null,
        ordDate: DateTime.now(),
        ordStartTime: DateTime.now(),
        ordEndTime: DateTime.now(),
        moneyFromCustomer: 0,
        totalPrice: 0,
        empId: emp_id,
        comm: '',
        isEnd: false,
        listOrders: []
      );
    } 

    factory Order.fromJson(Map<String, dynamic> json) {
      print(json);
      return Order(
        ordId: json['ord_id'],
        ordDate: DateTime.parse(json["ord_date"]),
        ordStartTime: DateTime.parse(json["ord_start_time"]),
        ordEndTime: DateTime.parse(json["ord_end_time"]),
        moneyFromCustomer: json["money_from_customer"].toDouble(),
        totalPrice: json['total_price'],
        empId: json["emp_id"],
        empName: json['emp_name'],
        comm: json["comm"],
        isEnd: json['is_end'] == 1 ? true : false,
        listOrders: List<OrderNode>.from(json['list_orders'].map((e) => OrderNode.fromJson(e)))
    );}

    Map<String, dynamic> toJson() => {
        // "ord_date": "${ordDate.year.toString().padLeft(4, '0')}-${ordDate.month.toString().padLeft(2, '0')}-${ordDate.day.toString().padLeft(2, '0')}",
        // "ord_start_time": ordStartTime,
        // "ord_end_time": ordEndTime,
        // "money_from_customer": moneyFromCustomer,
        "emp_id": empId,
        "comm": comm,
        "is_end": isEnd ? 1 : 0,
        "list_orders" : List<Map<String, dynamic>>.from(listOrders.map((e) => e.toJson()))
    };

    void refreshTotalPrice() => (listOrders.isNotEmpty) ? 
      totalPrice = listOrders.map<double>((e) => e.price).reduce((value, element) => value + element) : 
      totalPrice = 0;

    bool get payable => moneyFromCustomer >= totalPrice;
    bool get addable => empId != 0;
    double get change => moneyFromCustomer - totalPrice;
}


FilterSortEmployeeData filterSortEmployeeDataFromJson(String str) => FilterSortEmployeeData.fromJson(json.decode(str));

String filterSortEmployeeDataToJson(FilterSortEmployeeData data) => json.encode(data.toJson());

class FilterSortEmployeeData {
    FilterSortEmployeeData({
        required this.birthdayFrom,
        required this.birthdayTo,
        required this.hoursPerMonthFrom,
        required this.hoursPerMonthTo,
        required this.gender,
        required this.sortColumn,
        required this.asc
    });

    DateTime birthdayFrom;
    DateTime birthdayTo;
    int hoursPerMonthFrom;
    int hoursPerMonthTo;
    String gender;
    String sortColumn;
    String asc;
    List<int> roles = [];

    factory FilterSortEmployeeData.fromJson(Map<String, dynamic> json) => FilterSortEmployeeData(
        birthdayFrom: DateTime.parse(json["birthday_from"]),
        birthdayTo: DateTime.parse(json["birthday_to"]),
        hoursPerMonthFrom: json["hours_per_month_from"],
        hoursPerMonthTo: json["hours_per_month_to"],
        gender: json["gender"],
        sortColumn: json['sort_column'],
        asc: json['asc']
    );

    Map<String, dynamic> toJson() => {
        "birthday_from": "${birthdayFrom.year.toString().padLeft(4, '0')}-${birthdayFrom.month.toString().padLeft(2, '0')}-${birthdayFrom.day.toString().padLeft(2, '0')}",
        "birthday_to": "${birthdayTo.year.toString().padLeft(4, '0')}-${birthdayTo.month.toString().padLeft(2, '0')}-${birthdayTo.day.toString().padLeft(2, '0')}",
        "hours_per_month_from": hoursPerMonthFrom,
        "hours_per_month_to": hoursPerMonthTo,
        "gender": gender,
        'sort_column': sortColumn,
        'asc': asc,
        'roles': roles.join('+')
    };
}


/////////////////////////////..///..///......///..//////..//////......../////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////..///..///..///////..//////..//////..////..////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////.......///..../////..//////..//////..////..//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////..///..///..///////..//////..//////..////..////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////..///..///......///......//......//........////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


StatsData statsDataFromMap(Map<String, dynamic> map) => StatsData.fromJson(map);

class StatsData {
    StatsData({
        required this.ordPerPeriod,
        required this.dishPerPeriod,
        required this.empWorked,
    });

    List<OrdPerPeriod> ordPerPeriod;
    List<DishPerPeriod> dishPerPeriod;
    List<EmpWorked> empWorked;

    factory StatsData.fromJson(Map<String, dynamic> json) => StatsData(
        ordPerPeriod: List<OrdPerPeriod>.from(json["ord_per_period"].map((x) => OrdPerPeriod.fromJson(x))),
        dishPerPeriod: List<DishPerPeriod>.from(json["dish_per_period"].map((x) => DishPerPeriod.fromJson(x))),
        empWorked: List<EmpWorked>.from(json["emp_worked"].map((x) => EmpWorked.fromJson(x))),
    );
}

class DishPerPeriod {
    DishPerPeriod({
        required this.dishId,
        required this.dishName,
        required this.count,
    });

    int dishId;
    String dishName;
    int count;

    factory DishPerPeriod.fromJson(Map<String, dynamic> json) => DishPerPeriod(
        dishId: json["dish_id"],
        dishName: json["dish_name"],
        count: json["count"],
    );
}

class EmpWorked {
    EmpWorked({
        required this.empId,
        required this.empName,
        required this.worked,
        required this.hoursPerMonth,
    });

    int empId;
    String empName;
    int worked;
    int hoursPerMonth;

    factory EmpWorked.fromJson(Map<String, dynamic> json) => EmpWorked(
        empId: json["emp_id"],
        empName: json["emp_name"],
        worked: json["worked"],
        hoursPerMonth: json["hours_per_month"],
    );
}

class OrdPerPeriod {
    OrdPerPeriod({
        required this.ordStartTime,
        required this.count,
    });

    DateTime ordStartTime;
    int count;

    factory OrdPerPeriod.fromJson(Map<String, dynamic> json) => OrdPerPeriod(
        ordStartTime: DateTime.parse(json["ord_start_time"]),
        count: json["count"],
    );
}

class FilterSortStats {
  
  DateTime fromBase;
  DateTime toBase;
  DateTime ordFrom;
  DateTime ordTo;
  String group;
  DateTime dishFrom;
  DateTime dishTo;

  FilterSortStats({
    required this.fromBase,
    required this.toBase,
    required this.ordFrom,
    required this.ordTo,
    required this.group,
    required this.dishTo,
    required this.dishFrom
  });

  factory FilterSortStats.fromJson(Map<String, dynamic> json) => FilterSortStats(
    fromBase: DateTime.parse(json['from_base']),
    toBase: DateTime.parse(json['to_base']),
    ordFrom: DateTime.parse(json['ord_from']),
    ordTo: DateTime.parse(json['ord_to']),
    dishFrom: DateTime.parse(json['dish_from']),
    dishTo: DateTime.parse(json['dish_to']),
    group: json['group']
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ord_from' : ordFrom.  toIso8601String(),
      'ord_to'   : ordTo.    toIso8601String(),
      'dish_from': dishFrom. toIso8601String(),
      'dish_to'  : dishTo.   toIso8601String(),
      'group': group
    };
  }
}