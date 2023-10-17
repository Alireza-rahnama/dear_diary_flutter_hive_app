import 'package:hive/hive.dart';
import '../model/diary_model.dart';

class DiaryController {
  var box;

  DiaryController.initBox() {
    init();
  }

  // DiaryController() {
  //   init();
  // }

  Future<void> init() async {
    try {
      box = await Hive.openBox('diary_box');
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  void addDiary(DiaryModel diaryEntry) {
    if (!box.containsKey(diaryEntry.dateTime)) {
      box.add(diaryEntry);
    }
  }

  void updateDiary(int index, DiaryModel updatedDiary) {
    if (index >= 0 && index < box.length) {
      // Retrieve the existing entry from the box
      var existingDiary = box.getAt(index);

      if (existingDiary != null) {
        // Modify the existing entry with the updated values
        existingDiary.description = updatedDiary.description;
        existingDiary.dateTime = updatedDiary.dateTime;

        // Save the modified entry back into the box
        box.putAt(index, existingDiary);
      }
    }
  }

  void deleteDiaryAtIndex(int index) {
    box.deleteAt(index);
  }

  List<DiaryModel> getAllDiaryEntries() {
    if (box.values.isNotEmpty) {
      return box.values.toList();
    } else {
      return []; // Return an empty list if there are no entries
    }
  }
}
