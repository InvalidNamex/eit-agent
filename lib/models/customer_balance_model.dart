class CustomerBalanceModel {
  final String? custSign;
  final String? custName;
  final double? crLimit;
  final double? custBalance;

  const CustomerBalanceModel({
    this.custSign,
    this.custName,
    this.crLimit,
    this.custBalance,
  });

  static CustomerBalanceModel fromJson(Map<String, dynamic> json) =>
      CustomerBalanceModel(
        custSign: json['CustSign'] as String?,
        custName: json['CustName'] as String?,
        crLimit: (json['CrLimit'] as num?)?.toDouble(),
        custBalance: (json['CustBalance'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'CustSign': custSign,
        'CustName': custName,
        'CrLimit': crLimit,
        'CustBalance': custBalance,
      };
}
