import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/shop_state.dart';
import 'shop_test.mocks.dart';

part 'shop_test.g.dart';

// リポジトリ
@Riverpod(keepAlive: true)
ShopRepository shopRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ShopRepositoryImpl(ShopApi(dio));
}

class ShopApi {
  final Dio _dio;

  ShopApi(this._dio);

  // HTTP GET
  Future<List<ShopTestState>> getItems() async {
    final response = await _dio.get('https://shopmockapi-1.onrender.com/items');
    return (response.data as List).map((e) => ShopTestState.fromJson(e)).toList();
  }

  // HTTP POST
// POSTメソッドを追加
  Future<ShopTestState> addItem(ShopTestState item) async {
    final response = await _dio.post(
      'https://shopmockapi-1.onrender.com/items',
      data: item.toJson(),
    );
    return ShopTestState.fromJson(response.data);
  }
}

// リポジトリのインターフェース追加
abstract class ShopRepository {
  Future<List<ShopTestState>> getShops();
  Future<ShopTestState> addShop(ShopTestState shop);
}

// リポジトリの実装
class ShopRepositoryImpl implements ShopRepository {
  final ShopApi _api;

  ShopRepositoryImpl(this._api);

  @override
  Future<List<ShopTestState>> getShops() async {
    return await _api.getItems();
  }

  @override
  Future<ShopTestState> addShop(ShopTestState shop) async {
    return await _api.addItem(shop);
  }
}

// プロバイダー
@Riverpod(keepAlive: true)
Future<List<ShopTestState>> shop(Ref ref) async {
  final repository = ref.watch(shopRepositoryProvider);
  return repository.getShops();
}

// Dioプロバイダー
@Riverpod(keepAlive: true)
Dio dio(Ref ref) => Dio();

// テストコード
@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late ProviderContainer container;

  setUp(() {
    mockDio = MockDio();
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(mockDio),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Shop Tests', () {
    test('HTTP GET request succeeds', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
        data: [
          {'id': 1, 'item': 'Apple'},
          {'id': 2, 'item': 'Banana'},
        ],
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      final result = await container.read(shopProvider.future);

      expect(result.length, 2);
      expect(result[0].item, 'Apple');
      expect(result[1].item, 'Banana');
      verify(mockDio.get(any)).called(1);
    });

    test('throws exception on network error', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      expect(
            () => container.read(shopProvider.future),
        throwsA(isA<DioException>()),
      );
    });

    // POST リクエストのテスト
    test('HTTP POST request succeeds', () async {
      final newShop = ShopTestState(id: 3, item: 'Orange');
      final expectedUrl = 'https://shopmockapi-1.onrender.com/items';

      // モックの設定を修正
      when(mockDio.post(
        expectedUrl,
        data: anyNamed('data'),  // 名前付き引数として any を使用
      )).thenAnswer((_) async => Response(
        data: newShop.toJson(),
        statusCode: 201,
        requestOptions: RequestOptions(path: ''),
      ));

      final repository = ShopRepositoryImpl(ShopApi(mockDio));
      await repository.addShop(newShop);

      // 検証部分も修正
      verify(
        mockDio.post(
          expectedUrl,
          data: newShop.toJson(),
        ),
      ).called(1);
    });

    test('POST request fails with network error', () async {
      final newShop = ShopTestState(id: 3, item: 'Orange');
      final expectedUrl = 'https://shopmockapi-1.onrender.com/items';

      // エラーケースのモックも修正
      when(mockDio.post(
        expectedUrl,
        data: anyNamed('data'),  // 名前付き引数として any を使用
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      final repository = ShopRepositoryImpl(ShopApi(mockDio));

      expect(
            () => repository.addShop(newShop),
        throwsA(isA<DioException>()),
      );

      verify(
        mockDio.post(
          expectedUrl,
          data: anyNamed('data'),  // 検証時も名前付き引数として any を使用
        ),
      ).called(1);
    });
  });
}