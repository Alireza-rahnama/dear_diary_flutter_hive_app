import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import '../model/diary_model.dart';

class DiaryController {
  Box<DiaryModel> box = Hive.box('diary');

  // void addDiary(DiaryModel diaryEntry) {
  //   // final key = diaryEntry.dateTime.toIso8601String();
  //     box.add(diaryEntry);
  // }

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


  void addDiaryWithDateCheck(DiaryModel entry, List<DiaryModel> diaries) {
    bool shouldAdd = true;

    for (DiaryModel diary in diaries) {
      if (diary.dateTime.day == entry.dateTime.day) {
        shouldAdd = false;
        break; // Exit the loop as soon as a matching day is found
      }
    }

    if (shouldAdd) {
      box.add(entry);
    }
  }
}
