class ApiCustomerModel {
  final String? custName;
  final String? custCode;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? phoneNo;
  final String? taxNo;
  final int? salesRepId;

  const ApiCustomerModel({
    this.custName,
    this.custCode,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneNo,
    this.taxNo,
    this.salesRepId,
  });

  static ApiCustomerModel fromJson(Map<String, dynamic> json) =>
      ApiCustomerModel(
        custName: json['CustName'] as String?,
        custCode: json['CustCode'] as String?,
        address: json['Address'] as String?,
        latitude: json['Latitude'] as String?,
        longitude: json['Longitude'] as String?,
        phoneNo: json['PhoneNo'] as String?,
        taxNo: json['TaxNo'] as String?,
        salesRepId: json['SalesRepID'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'CustName': custName,
        'CustCode': custCode,
        'Address': address,
        'Latitude': latitude,
        'Longitude': longitude,
        'PhoneNo': phoneNo,
        'TaxNo': taxNo,
        'SalesRepID': salesRepId,
      };
}
