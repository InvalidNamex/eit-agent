class InvMasterModel {
  final int? id;
  final int? invType;
  final String? serial;
  final int? branchId;
  final int? salesRepId;
  final DateTime? invDate;
  final double? discountCash;
  final double? discBefore;
  final double? vat;
  final double? invAmount;
  final String? invNote;
  final String? custCode;
  final String? custName;
  final String? salesRepName;
  final int? paymentType;
  final String? address;

  const InvMasterModel({
    this.id,
    this.invType,
    this.serial,
    this.branchId,
    this.salesRepId,
    this.invDate,
    this.discountCash,
    this.discBefore,
    this.vat,
    this.invAmount,
    this.invNote,
    this.custCode,
    this.custName,
    this.salesRepName,
    this.paymentType,
    this.address,
  });

  factory InvMasterModel.fromJson(Map<String, dynamic> json) => InvMasterModel(
        id: json['ID'] != null ? int.tryParse(json['ID'].toString()) : null,
        invType: json['InvType'] != null
            ? int.tryParse(json['InvType'].toString())
            : null,
        serial: json['Serial'] as String?,
        branchId: json['BranchID'] != null
            ? int.tryParse(json['BranchID'].toString())
            : null,
        salesRepId: json['SalesRepID'] != null
            ? int.tryParse(json['SalesRepID'].toString())
            : null,
        invDate:
            json['InvDate'] != null ? DateTime.tryParse(json['InvDate']) : null,
        discountCash: json['DiscountCash'] != null
            ? double.tryParse(json['DiscountCash'].toString())
            : null,
        discBefore: json['DiscBefore'] != null
            ? double.tryParse(json['DiscBefore'].toString())
            : null,
        vat: json['VAT'] != null
            ? double.tryParse(json['VAT'].toString())
            : null,
        invAmount: json['InvAmount'] != null
            ? double.tryParse(json['InvAmount'].toString())
            : null,
        invNote: json['InvNote'] as String?,
        custCode: json['CustCode'] as String?,
        custName: json['CustName'] as String?,
        salesRepName: json['SalesRepName'] as String?,
        paymentType: json['PaymentType'] != null
            ? int.tryParse(json['PaymentType'].toString())
            : null,
        address: json['Address'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'ID': id?.toString(),
        'InvType': invType?.toString(),
        'Serial': serial,
        'BranchID': branchId?.toString(),
        'SalesRepID': salesRepId?.toString(),
        'InvDate': invDate?.toIso8601String(),
        'DiscountCash': discountCash?.toString(),
        'DiscBefore': discBefore?.toString(),
        'VAT': vat?.toString(),
        'InvAmount': invAmount?.toString(),
        'InvNote': invNote,
        'CustCode': custCode,
        'CustName': custName,
        'SalesRepName': salesRepName,
        'PaymentType': paymentType?.toString(),
        'Address': address,
      };
}
