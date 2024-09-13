class ApiInvoiceItem {
  final int itemId;
  final double price;
  final double quantity;
  final double discountPercentage;
  final double vatPercentage;

  ApiInvoiceItem({
    required this.itemId,
    required this.price,
    required this.quantity,
    required this.discountPercentage,
    required this.vatPercentage,
  });

  static ApiInvoiceItem fromJson(Map<String, dynamic> json) {
    return ApiInvoiceItem(
      itemId: json['ItemID'] as int,
      price: json['Price'] as double,
      quantity: json['Qty'] as double,
      discountPercentage: json['DiscPer'] as double,
      vatPercentage: json['VATPer'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemID': itemId,
      'Price': price,
      'Qty': quantity,
      'DiscPer': discountPercentage,
      'VATPer': vatPercentage,
    };
  }
}
