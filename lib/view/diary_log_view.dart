import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../controller/diary_controller.dart';
import '../model/diary_model.dart';
import 'diary_entry_view.dart';
import 'package:pdf/widgets.dart' as pw;


class DiaryLogView extends StatefulWidget {
  DiaryController diaryController = DiaryController();

  @override
  _DiaryLogViewState createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogView> {
  DateTime? selectedMonth;

  @override
  Widget build(BuildContext context) {
    // Get all diary entries
    List<DiaryModel> diaryEntries = widget.diaryController.getAllDiaryEntries();

    // Filter entries by selected month
    // List<DiaryModel> filteredEntries = selectedMonth != null
    //     ? diaryEntries.where((entry) {
    //   return entry.dateTime.month == selectedMonth.month;
    // }).toList()
    //     : diaryEntries;

    List<DiaryModel> filteredEntries = (selectedMonth != null)
        ? diaryEntries.where((entry) {
      return entry.dateTime.month == selectedMonth!.month;
    }).toList()
        : diaryEntries;

    // Sort the filtered entries in reverse chronological order (newest first)
    filteredEntries.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add New Entry',
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddDiaryEntryView()),
            );
          },
        ),
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Diary Entries',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            color: Colors.white,
            onPressed: () async {
              print("saved pdf file!");
              await exportToPDF(widget.diaryController);
            },
          ),
          // Add a filter button for selecting a month
          PopupMenuButton<DateTime>(
            onSelected: (DateTime month) {
              setState(() {
                selectedMonth = month;
              });
            },
            icon: Icon(Icons.filter_list, color: Colors.white,),
            itemBuilder: (BuildContext context) {
              // Create a list of months for filtering
              final List<DateTime> months = [
                DateTime(2023, 1), // January
                DateTime(2023, 2), // February
                DateTime(2023, 3), // March
                DateTime(2023, 4), // April
                DateTime(2023, 5), // May
                DateTime(2023, 6), // June
                DateTime(2023, 7), // July
                DateTime(2023, 8), // August
                DateTime(2023, 9), // September
                DateTime(2023, 10), // October
                DateTime(2023, 11), // November
                DateTime(2023, 12), // December
              ];

              return months.map((DateTime month) {
                return PopupMenuItem<DateTime>(
                  value: month,
                  child: Text(DateFormat('MMMM').format(month)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredEntries.length,
        itemBuilder: (context, index) {
          final entry = filteredEntries[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: GestureDetector(
              onLongPress: () {
                // Perform your action here when the Card is long-pressed.
                // For example, you can show a dialog or delete the Card.
                print('hello');
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.description,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            widget.diaryController.deleteDiaryAtIndex(index);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiaryLogView(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// Rest of your code...
}


Future<void> exportToPDF(DiaryController diaryController) async {
  // Create a new PDF document
  final pdf = pw.Document();

  // Retrieve data from Hive
  final hiveData = await diaryController.getAllDiaryEntries();



  List<pw.Widget> list = await pdfTextChildren(hiveData);

// In the Page build method:
  // Populate the PDF content with data
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: list,
        );
      },
    ),
  );


  // Save the PDF file
  final directory = await getApplicationDocumentsDirectory();
  print(directory);
  final file = File('${directory.path}/hive_data.pdf');
  // final file = File('fonts/hive_data.pdf');

  await file.writeAsBytes(await pdf.save());
}

Future<List<pw.Widget>> pdfTextChildren(List<DiaryModel> entries) async {
  List<pw.Widget> textList = [];
  // final ttf = File('/Users/alirezarahnama/StudioProjects/dear_diary_with_hive/fonts/Pacifico-Regular.ttf').readAsBytesSync();
  // final ttf = File('../../fonts/Pacifico-Regular.ttf').readAsBytesSync();
  final fontData = await rootBundle.load('fonts/Gabarito-VariableFont_wght.ttf');
  final ttf = fontData.buffer.asUint8List();
  final font = pw.Font.ttf(ttf.buffer.asByteData());

  for (DiaryModel entry in entries) {
    textList.add(
      pw.Text(
        'On ${DateFormat('yyyy-MM-dd').format(entry.dateTime)}, ${entry.description} was rated ${entry.rating} stars.',
        style: pw.TextStyle( font: font, fontSize: 12),
      ),
    );
  }
  return textList;
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
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star)
      ]);
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
