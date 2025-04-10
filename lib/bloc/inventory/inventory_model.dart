class InventoryItem {/// Model untuk item inventory yang akan digunakan dalam aplikasi.
  final String id; // ID unik untuk item inventory.
  final String name; // Nama item inventory.
  final String typeId; // ID jenis item inventory.
  final String typeName; // Nama jenis item inventory.
  final int quantity; // Jumlah item inventory.

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

