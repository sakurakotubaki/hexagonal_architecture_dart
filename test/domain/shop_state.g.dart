// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopTestStateImpl _$$ShopTestStateImplFromJson(Map<String, dynamic> json) =>
    _$ShopTestStateImpl(
      id: (json['id'] as num?)?.toInt(),
      item: json['item'] as String? ?? '',
    );

Map<String, dynamic> _$$ShopTestStateImplToJson(_$ShopTestStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item': instance.item,
    };
