class ItemModel {
  final int? id;
  final int? itemCode;
  final String? barCode;
  final String? itemName;
  final String? mainUnit;
  final double? price;
  final double? vat;
  final double? mainUnitPack;
  final double? subUnitPack;
  final String? mainUnit1;
  final String? subUnit;
  final String? smallUnit;
  final double? disc;
  final double? qtyBalance;
  final int? itemClassID;

  ItemModel({
    this.id,
    this.itemCode,
    this.barCode,
    this.itemName,
    this.mainUnit,
    this.price,
    this.vat,
    this.mainUnitPack,
    this.subUnitPack,
    this.mainUnit1,
    this.subUnit,
    this.smallUnit,
    this.disc,
    this.qtyBalance,
    this.itemClassID,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['ID'] != null ? int.tryParse(json['ID'].toString()) : null,
      itemClassID: json['ItemClassID'] != null
          ? int.tryParse(json['ItemClassID'].toString())
          : null,
      itemCode: json['ItemCode'] != null
          ? int.tryParse(json['ItemCode'].toString())
          : null,
      barCode: json['BarCode'] as String?,
      itemName: json['ItemName'] as String?,
      mainUnit: json['MainUnit'] as String?,
      price: json['Price'] != null
          ? double.tryParse(json['Price'].toString())
          : null,
      vat: json['VAT'] != null ? double.tryParse(json['VAT'].toString()) : null,
      mainUnitPack: json['MainUnitPack'] != null
          ? double.tryParse(json['MainUnitPack'].toString())
          : null,
      subUnitPack: json['SubUnitPack'] != null
          ? double.tryParse(json['SubUnitPack'].toString())
          : null,
      mainUnit1: json['MainUnit1'] as String?,
      subUnit: json['SubUnit'] as String?,
      smallUnit: json['SmallUnit'] as String?,
      disc: json['Disc'] != null
          ? double.tryParse(json['Disc'].toString())
          : null,
      qtyBalance: json['QtyBalance'] != null
          ? double.tryParse(json['QtyBalance'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'ID': id?.toString(),
        'ItemClassID': itemClassID,
        'ItemCode': itemCode?.toString(),
        'BarCode': barCode,
        'ItemName': itemName,
        'MainUnit': mainUnit,
        'Price': price?.toString(),
        'VAT': vat?.toString(),
        'MainUnitPack': mainUnitPack?.toString(),
        'SubUnitPack': subUnitPack?.toString(),
        'MainUnit1': mainUnit1,
        'SubUnit': subUnit,
        'SmallUnit': smallUnit,
        'Disc': disc?.toString(),
        'QtyBalance': qtyBalance?.toString(),
      };
}
