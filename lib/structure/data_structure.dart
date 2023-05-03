import 'package:hive/hive.dart';
part 'data_structure.g.dart';
@HiveType(typeId : 0)
class Data extends HiveObject {

  @HiveField(0)
  List<int> year;
  @HiveField(1)
  List<int>month;
  @HiveField(2)
  List<int>day;
  @HiveField(3)
  List<int>height;
  @HiveField(4)
  List<String> title;
  @HiveField(5)
  List<String>text;
  @HiveField(6)
  List<List<String>> image;
  @HiveField(7)
  List<DateTime> date;

  Data(this.year, this.month, this.day, this.height, this.title, this.text,
      this.image, this.date);

  Data.empty()
      :
        year=[],
        month=[],
        day=[],
        title=[],
        text=[],
        height=[],
        image=[],
        date=[];

  void addDiary(int y, int m, int d, DateTime dat, int hei, String tit,
      String tex, List<String> ima) {
    year.add(y);
    month.add(m);
    day.add(d);
    date.add(dat);
    height.add(hei);
    title.add(tit);
    text.add(tex);
    image.add(ima);
  }

  void removeAt(int i){
    year.removeAt(i);
    month.removeAt(i);
    day.removeAt(i);
    date.removeAt(i);
    height.removeAt(i);
    title.removeAt(i);
    text.removeAt(i);
    image.removeAt(i);
  }
}