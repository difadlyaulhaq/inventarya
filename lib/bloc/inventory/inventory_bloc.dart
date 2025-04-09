import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';
import 'inventory_model.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final FirebaseFirestore firestore;

  InventoryBloc({required this.firestore}) : super(InventoryInitial()) {
    on<UploadInventory>(_onUploadInventory);
    on<FetchInventories>(_onFetchInventories);
    on<UpdateInventory>(_onUpdateInventory);
  }

  Future<void> _onUploadInventory(
    UploadInventory event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryUploading());
    try {
      await firestore.collection('inventories').add(event.item.toMap());
      emit(InventoryUploaded());
      add(FetchInventories());
    } catch (e) {
      emit(InventoryUploadError(e.toString()));
    }
  }

  Future<void> _onFetchInventories(
    FetchInventories event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final snapshot = await firestore.collection('inventories').get();
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        return InventoryItem.fromMap(data);
      }).toList();
      emit(InventoryLoaded(items));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateInventory(
    UpdateInventory event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await firestore
          .collection('inventories')
          .doc(event.docId)
          .update(event.item.toMap());
      add(FetchInventories());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}

