// テストに必要なパッケージとファイルをインポート
import 'package:flutter_test/flutter_test.dart';
import 'shop_state.dart';

void main() {
  // group: 関連するテストをグループ化する
  // 'Shop Entity Tests': このグループのテストがShopエンティティに関するものと示す
  group('Shop Entity Tests', () {

    // test1: JSONからのインスタンス生成をテスト
    test('fromJson creates correct instance', () {
      // テスト用のJSONデータを定義
      final json = {'id': 1, 'item': 'Apple'};

      // ShopTestState.fromJson を使ってJSONからインスタンスを生成
      final shop = ShopTestState.fromJson(json);

      // expect: 期待値と実際の値を比較
      // shop.id が 1 であることを確認
      expect(shop.id, 1);
      // shop.item が 'Apple' であることを確認
      // 左が期待値、右が実際の値
      expect(shop.item, 'Apple');
    });

    // test2: copyWithメソッドの動作をテスト
    test('copyWith works correctly', () {
      // テスト用の初期インスタンスを作成
      const shop = ShopTestState(id: 1, item: 'Apple');

      // copyWithを使って item を 'Banana' に変更した新しいインスタンスを作成
      final updatedShop = shop.copyWith(item: 'Banana');

      // id は変更されていないことを確認（1のまま）
      expect(updatedShop.id, 1);
      // item が 'Banana' に変更されていることを確認
      expect(updatedShop.item, 'Banana');
    });
  });
}