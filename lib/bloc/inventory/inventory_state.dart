import 'package:inventarya/bloc/inventory/inventory_model.dart';
abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryUploading extends InventoryState {}

class InventoryUploaded extends InventoryState {}

class InventoryUploadError extends InventoryState {
  final String error;
  InventoryUploadError(this.error);
}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;
  InventoryLoaded(this.items);
}

class InventoryError extends InventoryState {
  final String error;
  InventoryError(this.error);
}
