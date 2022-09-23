import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/application.dart';
import 'package:online_tutor/restart_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RestartPage(child: Application()));
}

