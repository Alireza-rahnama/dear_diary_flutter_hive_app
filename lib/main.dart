import 'package:dear_diary_with_hive/view/diary_entry_view.dart';
import 'package:dear_diary_with_hive/view/diary_log_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controller/diary_controller.dart';
import 'model/diary_model.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //initilaize hive
  await Hive.initFlutter();

  Hive.registerAdapter(DiaryModelAdapter());

  //open box with encryption activated for storing data
  await Hive.openBox<DiaryModel>('diary');

  // var key = Hive.generateSecureKey();

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
