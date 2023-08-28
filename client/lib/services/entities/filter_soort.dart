
/// TODO: what is it used for????
class FilterSoort {
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