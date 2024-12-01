class CustomerModel {
  final int? id;
  final int? planID;
  final String? custCode;
  final String? custName;
  final String? phone;
  final String? gpsLocation;
  final String? address;
  final String? email;
  final String? ccSign;
  final String? ccName;

  const CustomerModel({
    this.id,
    this.planID,
    this.custCode,
    this.custName,
    this.phone,
    this.gpsLocation,
    this.address,
    this.email,
    this.ccSign,
    this.ccName,
  });

  static CustomerModel fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['ID'] != null
            ? int.tryParse(json['ID'].toString())
            : json['CustID'],
        planID: json['PlanID'] as int?,
        custCode: json['CustCode'] as String?,
        custName: json['CustName'] as String?,
        phone: json['Phone'] as String?,
        gpsLocation: json['GpsLocation'] as String?,
        address: json['Address'] as String?,
        email: json['Email'] as String?,
        ccSign: json['CCSign'] as String?,
        ccName: json['CCName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'ID': id?.toString(),
        'CustCode': custCode,
        'PlanID': planID,
        'CustName': custName,
        'Phone': phone,
        'GpsLocation': gpsLocation,
        'Address': address,
        'Email': email,
        'CCSign': ccSign,
        'CCName': ccName,
      };
}
