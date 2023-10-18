import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controller/diary_controller.dart';
import '../model/diary_model.dart';
import 'diary_entry_view.dart';

class DiaryLogView extends StatelessWidget {
  DiaryController diaryController = DiaryController();

  @override
  Widget build(BuildContext context) {
    // Sort the entries in reverse chronological order (newest first)
    // diaryController = DiaryController();
    List<DiaryModel> diaryEntries = diaryController.getAllDiaryEntries();

    diaryEntries.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Go back',
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDiaryEntryView()),
              );
            }),
        backgroundColor: Colors.deepPurple,
        title: Text('Diary Entries',
            style: GoogleFonts.pacifico(
              color: Colors.white,
              fontSize: 30.0,
            )
        ),
      ),
      body: ListView.builder(
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = diaryEntries[index];

          return Card(
              margin: EdgeInsets.all(8.0),
              child: GestureDetector(
                onLongPress: () {
                  // Perform your action here when the Card is long-pressed.
                  // For example, you can show a dialog or delete the Card.
                  print('hello');
                }, child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.description,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '${DateFormat('yyyy-MM-dd').format(entry.dateTime)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        RatingEvaluator(entry),
                        Spacer(),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.black,
                            onPressed: () {
                              diaryController.deleteDiaryAtIndex(index);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => DiaryLogView()),
                              // );
                            })

                        // Icon(Icons.delete)
                      ],
                    ),
                    // SizedBox(height: 10), // Add some spacing
                    // RatingEvaluator(entry),
                  ],
                ),
              ),
              )
          );
        },
      ),
    );
  }
}

Row RatingEvaluator(DiaryModel entry) {
  switch (entry.rating) {
    case (1):
      return Row(children: [
        Icon(Icons.star),
      ]);
    case (2):
      return Row(children: [Icon(Icons.star), Icon(Icons.star)]);
    case (3):
      return Row(
          children: [Icon(Icons.star), Icon(Icons.star), Icon(Icons.star)]);
    case (4):
      return Row(children: [ Icon(Icons.star), Icon(Icons.star), Icon(Icons.star), Icon(Icons.star)]);
    case (5):
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star)
      ]);
    default:
      return Row(); // Handle other cases or return an empty row if the rating is not 1-5.
  }
}
