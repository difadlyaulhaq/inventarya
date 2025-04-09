class InventoryItem {
  final String id;
  final String name;
  final String typeId;
  final String typeName;
  final int quantity;

  InventoryItem({
    required this.id,
    required this.name,
    required this.typeId,
    required this.typeName,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'typeId': typeId,
      'typeName': typeName,
      'quantity': quantity,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      typeId: map['typeId'] ?? '',
      typeName: map['typeName'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }
}

