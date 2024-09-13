class PoMasterModel {
  final int? transID;
  final int? branchId;
  final int? salesRepId;
  final DateTime? transDate;
  final String? transNotes;
  final String? custCode;
  final String? custName;
  final String? address;
  final String? salesRepName;
  final int? isCash;

  const PoMasterModel({
    this.transID,
    this.branchId,
    this.salesRepId,
    this.transDate,
    this.transNotes,
    this.custCode,
    this.custName,
    this.address,
    this.salesRepName,
    this.isCash,
  });

  factory PoMasterModel.fromJson(Map<String, dynamic> json) => PoMasterModel(
        transID: json['TransID'] as int?,
        branchId: json['BranchID'] as int?,
        salesRepId: json['SalesRepID'] as int?,
        transDate: json['TransDate'] != null
            ? DateTime.parse(json['TransDate'])
            : null,
        transNotes: json['TransNotes'] as String?,
        custCode: json['CustCode'] as String?,
        custName: json['CustName'] as String?,
        address: json['Address'] as String?,
        salesRepName: json['SalesRepName'] as String?,
        isCash: json['IsCash'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'TransID': transID,
        'BranchID': branchId,
        'SalesRepID': salesRepId,
        'TransDate': transDate?.toIso8601String(),
        'TransNotes': transNotes,
        'CustCode': custCode,
        'CustName': custName,
        'Address': address,
        'SalesRepName': salesRepName,
        'IsCash': isCash,
      };
}
