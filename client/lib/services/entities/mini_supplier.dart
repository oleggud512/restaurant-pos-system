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