class ApiInvoiceModel {
  final int? transID;
  final int? branchID;
  final int? salesRepID;
  final String? invDate;
  final double? invAmount;
  final String? invNote;
  final int? sysInvID;
  final String? custName;
  final String? salesRepName;

  ApiInvoiceModel({
    this.transID,
    this.branchID,
    this.salesRepID,
    this.invDate,
    this.invAmount,
    this.invNote,
    this.sysInvID,
    this.custName,
    this.salesRepName,
  });

  static ApiInvoiceModel fromJson(Map<String, dynamic> json) {
    return ApiInvoiceModel(
      transID: json['TransID'] as int?,
      branchID: json['BranchID'] as int?,
      salesRepID: json['SalesRepID'] as int?,
      invDate: json['InvDate'] as String?,
      invAmount: json['InvAmount'] as double?,
      invNote: json['InvNote'] as String?,
      sysInvID: json['SysInvID'] as int?,
      custName: json['CustName'] as String?,
      salesRepName: json['SalesRepName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TransID': transID,
      'BranchID': branchID,
      'SalesRepID': salesRepID,
      'InvDate': invDate,
      'InvAmount': invAmount,
      'InvNote': invNote,
      'SysInvID': sysInvID,
      'CustName': custName,
      'SalesRepName': salesRepName,
    };
  }
}
