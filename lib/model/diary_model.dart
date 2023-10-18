import 'package:hive/hive.dart';

part 'diary_model.g.dart';

@HiveType(typeId: 0)
class DiaryModel extends HiveObject {

  @HiveField(0)
  DateTime dateTime;
  @HiveField(1)
  var description;
  @HiveField(2)
  var rating;

  DiaryModel({required this.dateTime,
      required this.description,
      required this.rating});
}
