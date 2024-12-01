class CustomerLimitModel {
  final String custSign;
  final String custName;
  final double crLimit;
  final double custBalance;

  CustomerLimitModel({
    required this.custSign,
    required this.custName,
    required this.crLimit,
    required this.custBalance,
  });

  factory CustomerLimitModel.fromJson(Map<String, dynamic> json) {
    return CustomerLimitModel(
      custSign: json['CustSign'],
      custName: json['CustName'],
      crLimit: json['CrLimit'].toDouble(),
      custBalance: json['CustBalance'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustSign': custSign,
      'CustName': custName,
      'CrLimit': crLimit,
      'CustBalance': custBalance,
    };
  }
}
