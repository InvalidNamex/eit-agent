class SystemInfoModel {
  SystemInfoModel({
    this.invHeader,
    this.invPrintLogo,
    this.invPrintForm,
    this.invQtyUnit,
    this.recHeader,
    this.recPrintLogo,
    this.recPrintForm,
    this.transOnlyInLocation,
    this.custLocAcu,
    this.invPrintPrev,
    this.invPrintIncVAT,
    this.currencyName,
    this.currencySign,
    this.custSys,
    this.appVersion,
    this.downloadPath,
    this.mandatoryUpdate,
  });

  final String? invHeader;
  final String? invPrintLogo;
  final String? invPrintForm;
  final String? invQtyUnit;
  final String? recHeader;
  final String? recPrintLogo;
  final String? recPrintForm;
  final String? transOnlyInLocation;
  final String? custLocAcu;
  final String? invPrintPrev;
  final bool? invPrintIncVAT;
  final String? currencyName;
  final String? currencySign;
  final String? custSys;
  final String? appVersion;
  final String? downloadPath;
  final String? mandatoryUpdate;

  factory SystemInfoModel.fromJson(Map<String, dynamic> json) {
    return SystemInfoModel(
      invHeader: json["InvHeader"] as String?,
      invPrintLogo: json["InvPrintLogo"] as String?,
      invPrintForm: json["InvPrintForm"] as String?,
      invQtyUnit: json["InvQtyUnit"] as String?,
      recHeader: json["RecHeader"] as String?,
      recPrintLogo: json["RecPrintLogo"] as String?,
      recPrintForm: json["RecPrintForm"] as String?,
      transOnlyInLocation: json["TransOnlyInLocation"] as String?,
      custLocAcu: json["CustLocAcu"] as String?,
      invPrintPrev: json["InvPrintPrev"] as String?,
      invPrintIncVAT: json["InvPrintIncVAT"] as bool?,
      currencyName: json["CurrencyName"] as String?,
      currencySign: json["CurrencySign"] as String?,
      custSys: json["CustSys"] as String?,
      appVersion: json["AppVersion"] as String?,
      downloadPath: json["DownloadPath"] as String?,
      mandatoryUpdate: json["MandatoryUpdate"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "InvHeader": invHeader,
        "InvPrintLogo": invPrintLogo,
        "InvPrintForm": invPrintForm,
        "InvQtyUnit": invQtyUnit,
        "RecHeader": recHeader,
        "RecPrintLogo": recPrintLogo,
        "RecPrintForm": recPrintForm,
        "TransOnlyInLocation": transOnlyInLocation,
        "CustLocAcu": custLocAcu,
        "InvPrintPrev": invPrintPrev,
        "InvPrintIncVAT": invPrintIncVAT,
        "CurrencyName": currencyName,
        "CurrencySign": currencySign,
        "CustSys": custSys,
        "AppVersion": appVersion,
        "DownloadPath": downloadPath,
        "MandatoryUpdate": mandatoryUpdate,
      };
}
