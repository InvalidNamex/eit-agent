class ItemTreeModel {
  final int? id;
  final String? name;
  final int? level;

  const ItemTreeModel({
    this.id,
    this.name,
    this.level,
  });

  static ItemTreeModel fromJson(Map<String, dynamic> json) => ItemTreeModel(
        id: json['ID'] as int?,
        name: json['Name'] as String?,
        level: json['Level'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'ID': id,
        'Name': name,
        'Level': level,
      };
}
