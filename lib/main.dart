import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gestao/models/Exame.dart';
import 'package:gestao/pages/formularioExame.dart';
import 'package:gestao/pages/listaExame.dart';
import 'package:gestao/pages/listaGlicemia.dart';
import 'package:gestao/pages/listaPesoAltura.dart';
import 'package:gestao/pages/listaPressao.dart';
import 'package:gestao/pages/login.dart';
import 'package:gestao/pages/telaPrincipal.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.debug);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ye Gestão de Saúde',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(71, 146, 121, 0.612)),
        useMaterial3: true,
      ),
      home: login(),
    );
  }
}
