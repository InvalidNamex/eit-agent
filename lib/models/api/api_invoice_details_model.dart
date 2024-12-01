class InvDetailsModel {
  final String? itemCode;
  final String? itemName;
  final double? qty;
  final double? price;
  final double? discount;
  final double? vat;
  final double? vatAmount;

  const InvDetailsModel({
    this.itemCode,
    this.itemName,
    this.qty,
    this.price,
    this.discount,
    this.vat,
    this.vatAmount,
  });

  factory InvDetailsModel.fromJson(Map<String, dynamic> json) =>
      InvDetailsModel(
        itemCode: json['ItemCode'] as String?,
        itemName: json['ItemName'] as String?,
        qty: json['Qty'] != null
            ? double.tryParse(json['Qty'].toString())
            : null,
        price: json['Price'] != null
            ? double.tryParse(json['Price'].toString())
            : null,
        discount: json['Discount'] != null
            ? double.tryParse(json['Discount'].toString())
            : null,
        vat: json['VAT'] != null
            ? double.tryParse(json['VAT'].toString())
            : null,
        vatAmount: json['VATAmount'] != null
            ? double.tryParse(json['VATAmount'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'ItemCode': itemCode,
        'ItemName': itemName,
        'Qty': qty?.toString(),
        'Price': price?.toString(),
        'Discount': discount?.toString(),
        'VAT': vat?.toString(),
        'VATAmount': vatAmount?.toString(),
      };
}
