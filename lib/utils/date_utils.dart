import 'dart:core';

String toDateTimeStringZH({DateTime datetime, String formatString = 'yyyy-MM-dd hh-mm-ss'}){
	int year = datetime.year;
	int mouth = datetime.month;
	int day = datetime.day;
	int hours = datetime.hour;
	int minutes = datetime.minute;
	int second = datetime.second;

	String outString = formatString.replaceAll('yyyy', year.toString())
	.replaceAll('MM', mouth.toString())
	.replaceAll('dd', day.toString())
	.replaceAll('hh', hours.toString())
	.replaceAll('mm', minutes.toString())
	.replaceAll('ss', second.toString());

	return outString;
}

void test() {
	toDateTimeStringZH(datetime: new DateTime.now(), formatString: 'yyyy年MM月dd日 hh:mm分');
}