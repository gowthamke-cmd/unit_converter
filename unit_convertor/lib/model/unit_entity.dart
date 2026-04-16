import 'package:unit_convertor/generated/json/base/json_field.dart';
import 'package:unit_convertor/generated/json/unit_entity.g.dart';
import 'dart:convert';
export 'package:unit_convertor/generated/json/unit_entity.g.dart';

@JsonSerializable()
class UnitEntity {
  num? value;
	int? fromUnit;
	int? toUnit;
	int? category;
	num? precision;

	UnitEntity();

	factory UnitEntity.fromJson(Map<String, dynamic> json) => $UnitEntityFromJson(json);

	Map<String, dynamic> toJson() => $UnitEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}