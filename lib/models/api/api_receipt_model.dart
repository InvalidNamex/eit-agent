class ApiReceiptModel {
  final int? id;
  final String? transDt;
  final int? custId;
  final String? custCode;
  final String? custName;
  final double? payValue;
  final int? transStateAcc;
  final int? sysBatchId;
  final String? docNo;
  final String? notes;

  ApiReceiptModel({
    this.id,
    this.transDt,
    this.custId,
    this.custCode,
    this.custName,
    this.payValue,
    this.transStateAcc,
    this.sysBatchId,
    this.docNo,
    this.notes,
  });

  factory ApiReceiptModel.fromJson(Map<String, dynamic> json) {
    return ApiReceiptModel(
      id: json["ID"] as int?,
      transDt: json["TransDt"] as String?,
      custId: json["CustID"] as int?,
      custCode: json["CustCode"] as String?,
      custName: json["CustName"] as String?,
      payValue: json["PayValue"] as double?,
      transStateAcc: json["TransStateAcc"] as int?,
      sysBatchId: json["SysBatchID"] as int?,
      docNo: json["DocNo"] as String?,
      notes: json["Notes"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "TransDt": transDt,
        "CustID": custId,
        "CustCode": custCode,
        "CustName": custName,
        "PayValue": payValue,
        "TransStateAcc": transStateAcc,
        "SysBatchID": sysBatchId,
        "DocNo": docNo,
        "Notes": notes,
      };
}
