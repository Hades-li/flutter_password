import 'package:json_annotation/json_annotation.dart';

part 'psData.g.dart';

@JsonSerializable(nullable: false)
class PsItem {
	String id;
	String title;
	String password;
	PsItem({this.id, this.title, this.password});
	factory PsItem.fromJson(Map<String, dynamic> json) => _$PsItemFromJson(json);
	Map<String, dynamic> toJson() => _$PsItemToJson(this);
}


@JsonSerializable(nullable: false)
class PsData {
	String account;
	String id;
	List<PsItem> list;
	PsData(this.account,this.id,this.list);
	factory PsData.fromJson(Map<String, dynamic> json) => _$PsDataFromJson(json);
	Map<String, dynamic> toJson() => _$PsDataToJson(this);
}