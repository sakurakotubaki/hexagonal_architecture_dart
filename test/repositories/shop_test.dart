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

  Future<List<ShopTestState>> getItems() async {
    final response = await _dio.get('https://shopmockapi-1.onrender.com/items');
    return (response.data as List).map((e) => ShopTestState.fromJson(e)).toList();
  }
}

// リポジトリのインターフェース追加
abstract class ShopRepository {
  Future<List<ShopTestState>> getShops();
}

// リポジトリの実装
class ShopRepositoryImpl implements ShopRepository {
  final ShopApi _api;

  ShopRepositoryImpl(this._api);

  @override
  Future<List<ShopTestState>> getShops() async {
    return await _api.getItems();
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
    test('loads shops successfully', () async {
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
  });
}