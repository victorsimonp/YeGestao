import 'package:firebase_auth/firebase_auth.dart';
class Medicamentos {
  String nomeRemedio;
  String horario;
  String id;
  String periodo;
  String data;
  

  final FirebaseAuth auth = FirebaseAuth.instance;

  Medicamentos({
    required this.nomeRemedio,
    required this.horario,
    required this.id,
    required this.periodo,
    required this.data,
    
  });

  factory Medicamentos.fromMap(Map<String, dynamic> map) {
    return Medicamentos(
      id: map["id"] ?? '', // Use valor padrão se for nulo
      nomeRemedio: map["nomeRemedio"] ?? '', // Use valor padrão se for nulo
      horario: map["horario"] ?? '', // Use valor padrão se for nulo
      periodo: map["periodo"] ?? '',
      data: map["data"] ?? "",
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nomeRemedio": nomeRemedio,
      "horario": horario,
      "id": id,
      "periodo": periodo,
      "data" : data,
      
    };
  }
}
