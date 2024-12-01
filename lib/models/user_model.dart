class UserModel {
  final int? userID;
  final String? userName;
  final int? brID;
  final int? saleRepID;
  final int? storeID;
  final int? cashAccID;
  final bool? allowPriceChange;
  final bool? allowPriceChangeIfZero;
  final bool? allowDiscChange;
  final bool? allowQtyOverBal;
  final bool? allowDateChange;
  final bool? allowAddCust;

  const UserModel({
    this.userID,
    this.userName,
    this.brID,
    this.saleRepID,
    this.storeID,
    this.cashAccID,
    this.allowPriceChange,
    this.allowPriceChangeIfZero,
    this.allowDiscChange,
    this.allowQtyOverBal,
    this.allowDateChange,
    this.allowAddCust,
  });

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        userID: json['UserID'] as int?,
        userName: json['UserName'] as String?,
        brID: json['BrID'] as int?,
        saleRepID: json['SaleRepID'] as int?,
        storeID: json['StoreID'] as int?,
        cashAccID: json['CashAccID'] as int?,
        allowPriceChange: json['AllowPriceChange'] as bool?,
        allowPriceChangeIfZero: json['AllowPriceChangeIfZero'] as bool?,
        allowDiscChange: json['AllowDiscChange'] as bool?,
        allowQtyOverBal: json['AllowQtyOverBal'] as bool?,
        allowDateChange: json['AllowDateChange'] as bool?,
        allowAddCust: json['AllowAddCust'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'UserID': userID,
        'UserName': userName,
        'BrID': brID,
        'SaleRepID': saleRepID,
        'StoreID': storeID,
        'CashAccID': cashAccID,
        'AllowPriceChange': allowPriceChange,
        'AllowPriceChangeIfZero': allowPriceChangeIfZero,
        'AllowDiscChange': allowDiscChange,
        'AllowQtyOverBal': allowQtyOverBal,
        'AllowDateChange': allowDateChange,
        'AllowAddCust': allowAddCust,
      };
}
