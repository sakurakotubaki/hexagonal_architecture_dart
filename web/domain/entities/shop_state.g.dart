// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopStateImpl _$$ShopStateImplFromJson(Map<String, dynamic> json) =>
    _$ShopStateImpl(
      id: (json['id'] as num?)?.toInt(),
      item: json['item'] as String? ?? '',
    );

Map<String, dynamic> _$$ShopStateImplToJson(_$ShopStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item': instance.item,
    };
