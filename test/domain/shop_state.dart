import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'shop_state.freezed.dart';
part 'shop_state.g.dart';

@freezed
class ShopTestState with _$ShopTestState {
  const factory ShopTestState({
    int? id,
    @Default('') String item,
  }) = _ShopTestState;

  factory ShopTestState.fromJson(Map<String, Object?> json) => _$ShopTestStateFromJson(json);
}