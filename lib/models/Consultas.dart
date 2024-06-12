import 'package:firebase_auth/firebase_auth.dart';
class Consultas {
  String especialidade;
  String horario;
  String id;
  String resumo;
  String data;
   String retorno;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Consultas({
    required this.especialidade,
    required this.horario,
    required this.id,
    required this.resumo,
    required this.data,
    required this.retorno
  });

  factory Consultas.fromMap(Map<String, dynamic> map) {
    return Consultas(
      id: map["id"] ?? '', // Use valor padrão se for nulo
      especialidade: map["especialidade"] ?? '', // Use valor padrão se for nulo
      horario: map["horario"] ?? '', // Use valor padrão se for nulo
      resumo: map["resumo"] ?? '',
      data: map["data"] ?? "",
      retorno: map["retorno"] ?? ""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "especialidade": especialidade,
      "horario": horario,
      "id": id,
      "resumo": resumo,
      "data" : data,
      "retorno" : retorno
    };
  }
}
