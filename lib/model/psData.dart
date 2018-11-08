import 'package:json_annotation/json_annotation.dart';

part 'psData.g.dart';

@JsonSerializable(nullable: false)
class PsItem {
	final String id;
	final String title;
	final String password;
	PsItem({this.id, this.title, this.password});
	factory PsItem.fromJson(Map<String, dynamic> json) => _$PsItemFromJson(json);
	Map<String, dynamic> toJson() => _$PsItemToJson(this);
}


@JsonSerializable(nullable: false)
class PsData {
	final String account;
	final String id;
	final List<PsItem> list;
	PsData(this.account,this.id,this.list);
	factory PsData.fromJson(Map<String, dynamic> json) => _$PsDataFromJson(json);
	Map<String, dynamic> toJson() => _$PsDataToJson(this);
}