import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'shop_state.freezed.dart';
part 'shop_state.g.dart';

@freezed
class ShopState with _$ShopState {
  const factory ShopState({
    int? id,
    @Default('') String item,
  }) = _ShopState;

  factory ShopState.fromJson(Map<String, Object?> json) => _$ShopStateFromJson(json);
}