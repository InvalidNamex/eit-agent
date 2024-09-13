class SalesAnalysisModel {
  final String? invSerial; // Invoice serial number
  final DateTime? invDate; // Invoice date
  final double? invDiscount; // Invoice discount
  final double? itemDiscount; // Item discount
  final double? vat; // VAT percentage
  final double? netTotal; // Net total
  final String? custName; // Customer name
  final String? invTypeName; // Invoice type name

  const SalesAnalysisModel({
    this.invSerial,
    this.invDate,
    this.invDiscount,
    this.itemDiscount,
    this.vat,
    this.netTotal,
    this.custName,
    this.invTypeName,
  });

  factory SalesAnalysisModel.fromJson(Map<String, dynamic> json) =>
      SalesAnalysisModel(
        invSerial: json['InvSerial'] as String?,
        invDate: json['InvDate'] != null
            ? DateTime.parse(json['InvDate'] as String)
            : null,
        invDiscount: json['InvDiscount'] != null
            ? double.tryParse(json['InvDiscount'].toString())
            : null,
        itemDiscount: json['ItemDiscount'] != null
            ? double.tryParse(json['ItemDiscount'].toString())
            : null,
        vat: json['VAT'] != null
            ? double.tryParse(json['VAT'].toString())
            : null,
        netTotal: json['NetTotal'] != null
            ? double.tryParse(json['NetTotal'].toString())
            : null,
        custName: json['CustName'] as String?,
        invTypeName: json['InvTypeName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'InvSerial': invSerial,
        'InvDate': invDate?.toIso8601String(),
        'InvDiscount': invDiscount?.toString(),
        'ItemDiscount': itemDiscount?.toString(),
        'VAT': vat?.toString(),
        'NetTotal': netTotal?.toString(),
        'CustName': custName,
        'InvTypeName': invTypeName,
      };
}
