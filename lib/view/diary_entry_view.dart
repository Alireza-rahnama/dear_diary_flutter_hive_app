import 'package:dear_diary_with_hive/controller/diary_controller.dart';
import 'package:dear_diary_with_hive/model/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'diary_log_view.dart';

class AddDiaryEntryView extends StatefulWidget {

  @override
  _AddDiaryEntryViewState createState() => _AddDiaryEntryViewState();
}

class _AddDiaryEntryViewState extends State<AddDiaryEntryView> {

  final TextEditingController descriptionController = TextEditingController();
  double rating = 3.0; // Initial rating value
  DateTime selectedDate = DateTime.now(); // Initial date value
  late String description;
  var diaryController = DiaryController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _saveDiaryEntry() async{
    description = descriptionController.text;
    DiaryModel diaryEntry = DiaryModel(
        dateTime: selectedDate, description: description, rating: rating);
    // DiaryController diaryController = DiaryController();
    // diaryController.addDiary(diaryEntry);
    // diaryController.addDiaryWithDateCheck(diaryEntry);
    diaryController.addDiary(diaryEntry);
    // descriptionController.clear();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => DiaryLogView()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
              "Add Diary Entry",
              style: GoogleFonts.pacifico(
                color: Colors.white,
                fontSize: 30.0,
              )
          ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            tooltip: 'Go back',
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiaryLogView()),
              );
            }),
          // actions: <Widget>[
          //   IconButton(
          //     color: Colors.white,
          //     icon: const Icon(Icons.arrow_back_outlined),
          //     tooltip: 'Go back',
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => DiaryLogView),
          //       );
          //     },
          //   ),
          // ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter your description (max 140 characters)',
              ),
              maxLength: 140, // Set the maximum character limit
              maxLines: null, // Allow multiple lines of text
            ),
            Text('Enter your description (max 140 characters)',
                style: TextStyle(
                  color: Colors.grey, // Customize the hint text color
                  fontSize: 12, // Customize the hint text font size
                )),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Rate Your Day: ${rating.toInt()} Stars'),
                Slider(
                  value: rating,
                  min: 1,
                  max: 5,
                  onChanged: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Date: ${selectedDate.toLocal()}'.split(' ')[0]),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child:
                      Text('${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                ),
              ],
            ),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: _saveDiaryEntry,
              child: Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(home: AddDiaryEntryView()));
// }
