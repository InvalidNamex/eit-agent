class StockItemModel {
  final int? itemId;
  final String? itemCode;
  final String? itemName;
  final double? quantity;
  final String? mainUnit;
  final String? subUnit;
  final String? smallUnit;
  final double? mainUnitPack;
  final double? subUnitPack;

  StockItemModel({
    this.itemId,
    this.itemCode,
    this.itemName,
    this.quantity,
    this.mainUnit,
    this.subUnit,
    this.smallUnit,
    this.mainUnitPack,
    this.subUnitPack,
  });

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
      itemId: json['ItemID'] != null
          ? int.tryParse(json['ItemID'].toString())
          : null,
      itemCode: json['ItemCode'] as String?,
      itemName: json['ItemName'] as String?,
      quantity:
          json['Q'] != null ? double.tryParse(json['Q'].toString()) : null,
      mainUnit: json['MainUnit'] as String?,
      subUnit: json['SubUnit'] as String?,
      smallUnit: json['SmallUnit'] as String?,
      mainUnitPack: json['MainUnitPack'] != null
          ? double.tryParse(json['MainUnitPack'].toString())
          : null,
      subUnitPack: json['SubUnitPack'] != null
          ? double.tryParse(json['SubUnitPack'].toString())
          : null,
    );
  }
}
