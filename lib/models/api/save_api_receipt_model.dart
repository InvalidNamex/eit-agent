class SaveReceiptModel {
  SaveReceiptModel({
    this.payDate,
    this.custId,
    this.salesRepId,
    this.payNote,
    this.latitude,
    this.longitude,
    this.amount,
  });

  final String? payDate;
  final int? custId;
  final int? salesRepId;
  final String? payNote;
  final String? latitude;
  final String? longitude;
  final double? amount;

  factory SaveReceiptModel.fromJson(Map<String, dynamic> json) {
    return SaveReceiptModel(
      payDate: json["PayDate"] as String?,
      custId: json["CustID"] as int?,
      salesRepId: json["SalesRepID"] as int?,
      payNote: json["PayNote"] as String?,
      latitude: json["Latitude"] as String?,
      longitude: json["Longitude"] as String?,
      amount: json["Amount"] as double?,
    );
  }

  Map<String, dynamic> toJson() => {
        "PayDate": payDate,
        "CustID": custId,
        "SalesRepID": salesRepId,
        "PayNote": payNote,
        "Latitude": latitude,
        "Longitude": longitude,
        "Amount": amount,
      };
}
