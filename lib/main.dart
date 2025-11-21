import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_chappo/basic_print.dart';
import 'package:new_chappo/brochures.dart';
import 'package:new_chappo/bulkorder.dart';
import 'package:new_chappo/business_card.dart';
import 'package:new_chappo/dashboard.dart';
import 'package:new_chappo/gift_card.dart';
import 'package:new_chappo/sign_in_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override// for MediaType
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chhapo',
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.deepPurple),
      home: Dashboard(),
    );
  }
}
