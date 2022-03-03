import 'dart:convert';

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