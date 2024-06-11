import 'package:firebase_auth/firebase_auth.dart';

class Exame {
  String data;
  String nomeExame;
  String arquivo;
  bool imagem;
  String id;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Exame({
    required this.data,
    required this.nomeExame,
    required this.arquivo,
    required this.imagem,
    required this.id,
  });

  factory Exame.fromMap(Map<String, dynamic> map) {
    return Exame(
        data: map["data"],
        nomeExame: map["nomeExame"],
        arquivo: map["arquivo"],
        imagem: map["imagem"],
        id: map["id"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "data": data,
      "nomeExame": nomeExame,
      "arquivo": arquivo,
      "imagem": imagem,
      "id":id

    };
  }
}
