import 'package:flutter/material.dart';

import '../controller/diary_controller.dart';
import '../model/diary_model.dart';

class DiaryLogView extends StatelessWidget {
  var diaryController;

  @override
  Widget build(BuildContext context) {
    // Sort the entries in reverse chronological order (newest first)
    diaryController = DiaryController.initBox();
    List<DiaryModel> diaryEntries = diaryController.getAllDiaryEntries();

    diaryEntries.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: Text('Diary Entries'),
      ),
      body: ListView.builder(
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = diaryEntries[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(entry.description),
              subtitle: Text('Rating: ${entry.rating.toStringAsFixed(1)}'),
              trailing: Text('Date: ${entry.dateTime.toString()}'),
            ),
          );
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Diary Entries'),
  //     ),
  //     body: FutureBuilder(
  //       future: diaryController,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           // Now you can safely use diaryController.box to access the Hive box
  //           List<DiaryModel> diaryEntries = diaryController.getAllDiaryEntries();
  //
  //           return ListView.builder(
  //             itemCount: diaryEntries.length,
  //             itemBuilder: (context, index) {
  //               final entry = diaryEntries[index];
  //
  //               return Card(
  //                 margin: EdgeInsets.all(8.0),
  //                 child: ListTile(
  //                   title: Text(entry.description),
  //                   subtitle: Text('Rating: ${entry.rating.toStringAsFixed(1)}'),
  //                   trailing: Text('Date: ${entry.dateTime.toString()}'),
  //                 ),
  //               );
  //             },
  //           );
  //
  //         } else {
  //           return CircularProgressIndicator(); // or another loading indicator
  //         }
  //       },
  //     ),
  //   );
  // }
}
