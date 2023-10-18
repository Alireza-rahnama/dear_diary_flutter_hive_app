import 'package:dear_diary_with_hive/view/diary_log_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/diary_model.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  // //initilaize hive
  await Hive.initFlutter();
  //
  Hive.registerAdapter(DiaryModelAdapter());
  //
  var key = Hive.generateSecureKey();
  // //open box with encryption activated for storing data
  await Hive.openBox<DiaryModel>('diary');


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DiaryLogView()
    );
  }
}