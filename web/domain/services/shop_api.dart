import 'package:dio/dio.dart';
import 'package:hexagonal_architecture_dart/application/domain/entities/shop_state.dart';
import 'package:hexagonal_architecture_dart/common/base_url.dart';
import 'package:retrofit/retrofit.dart';

part 'shop_api.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class ShopApi {
  factory ShopApi(Dio dio, {String baseUrl}) = _ShopApi;

  // create data
  @POST('/items')
  Future<ShopState> createItem(@Query('item_name') String itemName);

  // all data
  @GET('/items')
  Future<List<ShopState>> getItems();

  // only get one data
  @GET('/items/{id}')
  Future<ShopState> getOneItem(@Path() int id);

  // delete data
  @DELETE('/items/{id}')
  Future<ShopState> deleteItem(@Path() int id);
}