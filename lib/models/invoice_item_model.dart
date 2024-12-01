class InvoiceItemModel {
  String? itemName;
  String? quantity;
  double? price;
  double? discount;
  double? tax;
  double? total;
  double? mainQty;
  double? subQty;
  double? smallQty;

  InvoiceItemModel(
      {this.itemName,
      this.quantity,
      this.price,
      this.discount,
      this.tax,
      this.total,
      this.mainQty,
      this.subQty,
      this.smallQty});

  static InvoiceItemModel fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      itemName: json['ItemName'] as String?,
      quantity: json['Quantity'] as String?,
      price: json['Price'] as double?,
      discount: json['Discount'] as double?,
      tax: json['Tax'] as double?,
      total: json['Total'] as double?,
      mainQty: json['mainQty'] as double?,
      subQty: json['subQty'] as double?,
      smallQty: json['smallQty'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemName': itemName,
      'Quantity': quantity,
      'Price': price,
      'Discount': discount,
      'Tax': tax,
      'Total': total,
      // 'mainQty': mainQty,
      // 'subQty': subQty,
      // 'smallQty': smallQty,
    };
  }
}
