class PODetailModel {
  String? itemCode;
  String? itemName;
  double? qty;
  double? price;
  double? discPer;
  double? taxPer;

  PODetailModel({
    this.itemCode,
    this.itemName,
    this.qty,
    this.price,
    this.discPer,
    this.taxPer,
  });

  // Factory method to create an instance of ItemModel from JSON
  factory PODetailModel.fromJson(Map<String, dynamic> json) {
    return PODetailModel(
      itemCode: json['ItemCode'] as String?,
      itemName: json['ItemName'] as String?,
      qty: (json['Qty'] as num?)?.toDouble(),
      price: (json['Price'] as num?)?.toDouble(),
      discPer: (json['DiscPer'] as num?)?.toDouble(),
      taxPer: (json['TaxPer'] as num?)?.toDouble(),
    );
  }

  // Method to convert an instance of ItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'ItemCode': itemCode,
      'ItemName': itemName,
      'Qty': qty,
      'Price': price,
      'DiscPer': discPer,
      'TaxPer': taxPer,
    };
  }
}
