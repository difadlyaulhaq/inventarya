import 'package:equatable/equatable.dart';
import 'inventory_model.dart';

abstract class InventoryEvent {}

class UploadInventory extends InventoryEvent {
  final InventoryItem item;
  UploadInventory(this.item);
}

class FetchInventories extends InventoryEvent {}

class UpdateInventory extends InventoryEvent {
  final String docId;
  final InventoryItem item;
  UpdateInventory({required this.docId, required this.item});
}

