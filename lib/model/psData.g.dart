// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PsItem _$PsItemFromJson(Map<String, dynamic> json) {
  return PsItem(
      id: json['id'] as String,
      title: json['title'] as String,
      password: json['password'] as String);
}

Map<String, dynamic> _$PsItemToJson(PsItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'password': instance.password
    };

PsData _$PsDataFromJson(Map<String, dynamic> json) {
  return PsData(
      account: json['account'] as String,
      id: json['id'] as String,
      list: (json['list'] as List)
          .map((e) => PsItem.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$PsDataToJson(PsData instance) => <String, dynamic>{
      'account': instance.account,
      'id': instance.id,
      'list': instance.list
    };
