class CashFlowModel {
  final int? id;
  final DateTime? moveDate;
  final double? eqDebit;
  final double? eqCredit;
  final String? masterNote;

  const CashFlowModel({
    this.id,
    this.moveDate,
    this.eqDebit,
    this.eqCredit,
    this.masterNote,
  });

  static CashFlowModel fromJson(Map<String, dynamic> json) => CashFlowModel(
        id: json['ID'] as int?,
        moveDate:
            json['MoveDate'] != null ? DateTime.parse(json['MoveDate']) : null,
        eqDebit: (json['EqDebit'] as num?)?.toDouble(),
        eqCredit: (json['EqCredit'] as num?)?.toDouble(),
        masterNote: json['MasterNote'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'ID': id,
        'MoveDate': moveDate?.toIso8601String(),
        'EqDebit': eqDebit,
        'EqCredit': eqCredit,
        'MasterNote': masterNote,
      };
}
