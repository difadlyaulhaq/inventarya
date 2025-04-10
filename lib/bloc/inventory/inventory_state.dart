import 'package:inventarya/bloc/inventory/inventory_model.dart';
abstract class InventoryState {}

class InventoryInitial extends InventoryState {} // Initial state when the app starts

class InventoryUploading extends InventoryState {} // State when inventory is being uploaded

class InventoryUploaded extends InventoryState {} // State when inventory is successfully uploaded

class InventoryUploadError extends InventoryState {
  final String error;
  InventoryUploadError(this.error);
}// State when there is an error during inventory upload

class InventoryLoading extends InventoryState {}// State when inventory is being loaded

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;
  InventoryLoaded(this.items);
}// State when inventory is successfully loaded

class InventoryError extends InventoryState {
  final String error;
  InventoryError(this.error);
}// State when there is an error during inventory loading
