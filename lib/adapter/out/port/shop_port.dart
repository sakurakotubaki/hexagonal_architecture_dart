import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexagonal_architecture_dart/application/domain/entities/shop_state.dart';
import 'package:hexagonal_architecture_dart/application/domain/services/shop_api.dart';
import 'package:hexagonal_architecture_dart/common/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_port.g.dart';

abstract interface class ShopPort {
  Future<List<ShopState>> getItems();
  Future<ShopState> getOneItem(int id);
  Future<ShopState> createItem(ShopState itemName);
  Future<ShopState> deleteItem(int id);
}

@riverpod
ShopPort shopPort(Ref ref) {
  final dio = ref.watch(dioProvider);
  final api = ShopApi(dio);
  return ShopAdapter(api);
}

class ShopAdapter implements ShopPort {
  final ShopApi _api;

  ShopAdapter(this._api);

  @override
  Future<ShopState> createItem(ShopState itemName) async {
    return await _api.createItem(itemName);
  }

  @override
  Future<ShopState> deleteItem(int id) async {
    return await _api.deleteItem(id);
  }

  @override
  Future<List<ShopState>> getItems() async {
    return await _api.getItems();
  }

  @override
  Future<ShopState> getOneItem(int id) async {
    return await _api.getOneItem(id);
  }
}
