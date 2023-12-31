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
        existingDiary.rating = updatedDiary.rating;

        // Save the modified entry back into the box
        box.putAt(index, existingDiary);
      }
    }
  }

  void deleteDiaryAtIndex(int index) {
    box.deleteAt(index);
  }

  void deleteDiaryAtDate(DateTime entryDateToRemove, List<DiaryModel> filteredEntries) {
    var keys = box.keys.toList();

    for (int key in keys) {
      var entry = box.get(key);
      if (entry!.dateTime == entryDateToRemove) {
        // Remove the entry with a matching date
        box.delete(key);
      }
    }
  }

  List<DiaryModel> getAllDiaryEntries() {
    if (box.values.isNotEmpty) {
      return box.values.toList();
    } else {
      return []; // Return an empty list if there are no entries
    }
  }

  List<DiaryModel> filterDiaryEntriesByMonth(
      List<DiaryModel> diaryEntries, int selectedMonth) {
    var allDiaries = diaryEntries;
    List<DiaryModel> filteredDiaries = [];

    for (DiaryModel diary in allDiaries) {
      if (diary.dateTime.month == selectedMonth) {
        filteredDiaries.add(diary);
      }
    }

    return filteredDiaries;
  }

  List<DiaryModel> filterEncryptedDiaryEntriesByMonth(
      List<DiaryModel> diaryEntries, int selectedMonth) {
    var allDiaries = diaryEntries;
    List<DiaryModel> filteredDiaries = [];

    for (DiaryModel diary in allDiaries) {
      if (diary.dateTime.month == selectedMonth) {
        filteredDiaries.add(diary);
      }
    }

    return filteredDiaries;
  }

  bool addDiaryWithDateCheck(DiaryModel entry, List<DiaryModel> diaries) {
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
    return shouldAdd;
  }

  bool putEncryptedDiaryWithDateCheck(
      DiaryModel entry, List<DiaryModel> diaries) {
    bool shouldAdd = true;

    for (DiaryModel diary in diaries) {
      if (diary.dateTime.day == entry.dateTime.day) {
        shouldAdd = false;
        break; // Exit the loop as soon as a matching day is found
      }
    }

    if (shouldAdd) {
      box.put(entry.dateTime, entry);
    }
    return shouldAdd;
  }
}
