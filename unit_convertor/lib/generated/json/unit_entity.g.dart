import 'package:unit_convertor/generated/json/base/json_convert_content.dart';
import 'package:unit_convertor/model/unit_entity.dart';

UnitEntity $UnitEntityFromJson(Map<String, dynamic> json) {
  final UnitEntity unitEntity = UnitEntity();
  final num? value = jsonConvert.convert<num>(json['value']);
  if (value != null) {
    unitEntity.value = value;
  }
  final int? fromUnit = jsonConvert.convert<int>(json['fromUnit']);
  if (fromUnit != null) {
    unitEntity.fromUnit = fromUnit;
  }
  final int? toUnit = jsonConvert.convert<int>(json['toUnit']);
  if (toUnit != null) {
    unitEntity.toUnit = toUnit;
  }
  final int? category = jsonConvert.convert<int>(json['category']);
  if (category != null) {
    unitEntity.category = category;
  }
  final num? precision = jsonConvert.convert<num>(json['precision']);
  if (precision != null) {
    unitEntity.precision = precision;
  }
  return unitEntity;
}

Map<String, dynamic> $UnitEntityToJson(UnitEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['value'] = entity.value;
  data['fromUnit'] = entity.fromUnit;
  data['toUnit'] = entity.toUnit;
  data['category'] = entity.category;
  data['precision'] = entity.precision;
  return data;
}

extension UnitEntityExtension on UnitEntity {
  UnitEntity copyWith({
    num? value,
    int? fromUnit,
    int? toUnit,
    int? category,
    num? precision,
  }) {
    return UnitEntity()
      ..value = value ?? this.value
      ..fromUnit = fromUnit ?? this.fromUnit
      ..toUnit = toUnit ?? this.toUnit
      ..category = category ?? this.category
      ..precision = precision ?? this.precision;
  }
}