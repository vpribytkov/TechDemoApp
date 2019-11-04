// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    expirationDate: json['expirationDate'] == null
        ? null
        : DateTime.parse(json['expirationDate'] as String),
    priority: _$enumDecodeNullable(_$PriorityEnumMap, json['priority']),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'creationDate': instance.creationDate?.toIso8601String(),
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'priority': _$PriorityEnumMap[instance.priority],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PriorityEnumMap = {
  Priority.Low: 'Low',
  Priority.Medium: 'Medium',
  Priority.High: 'High',
};
