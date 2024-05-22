import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Exame {
  String data;
  String nomeExame;
  String arquivo;
  bool imagem;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Exame({
    required this.data,
    required this.nomeExame,
    required this.arquivo,
    required this.imagem,
  });

  factory Exame.fromMap(Map<String, dynamic> map) {
    return Exame(
        data: map["data"],
        nomeExame: map["nomeExame"],
        arquivo: map["arquivo"],
        imagem: map["imagem"]);
  }
  factory Exame.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Exame(
        data: data?["data"],
        nomeExame: data?["nomeExame"],
        arquivo: data?["arquivo"],
        imagem: data?["imagem"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "data": data,
      "nomeExame": nomeExame,
      "arquivo": arquivo,
      "imagem": imagem,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "data": data,
      "nomeExame": nomeExame,
      "arquivo": arquivo,
      "imagem": imagem
    };
  }
}