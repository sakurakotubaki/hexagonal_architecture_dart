import 'package:hexagonal_architecture_dart/adapter/out/port/shop_port.dart';
import 'package:hexagonal_architecture_dart/application/domain/entities/shop_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_controller.g.dart';

@riverpod
class ShopController extends _$ShopController {
  @override
  Future<List<ShopState>> build() async {
    return getItems();
  }

  Future<List<ShopState>> getItems() async {
    return await ref.read(shopPortProvider).getItems();
  }

  Future<ShopState> createItem(String itemName) async {
    return await ref.read(shopPortProvider).createItem(itemName);
  }

  Future<ShopState> deleteItem(int id) async {
    return await ref.read(shopPortProvider).deleteItem(id);
  }
}