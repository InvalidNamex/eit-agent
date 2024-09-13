class ApiSaveInvoiceModel {
  final String invDate;
  final int custID;
  final int salesRepID;
  final int payType;
  final String invNote;
  final String latitude;
  final String longitude;
  final List<Map<String, dynamic>> products;

  ApiSaveInvoiceModel({
    required this.invDate,
    required this.custID,
    required this.salesRepID,
    required this.payType,
    required this.invNote,
    required this.latitude,
    required this.longitude,
    required this.products,
  });

  factory ApiSaveInvoiceModel.fromJson(Map<String, dynamic> json) {
    return ApiSaveInvoiceModel(
        invDate: json['InvDate'],
        custID: json['CustID'],
        salesRepID: json['SalesRepID'],
        payType: json['PayType'],
        invNote: json['InvNote'],
        latitude: json['Latitude'],
        longitude: json['Longitude'],
        products: json['Products']);
  }

  Map<String, dynamic> toJson() {
    return {
      'InvDate': invDate,
      'CustID': custID,
      'SalesRepID': salesRepID,
      'PayType': payType,
      'InvNote': invNote,
      'Latitude': latitude,
      'Longitude': longitude,
      'Products': products,
    };
  }
}
