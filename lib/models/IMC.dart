import 'package:firebase_auth/firebase_auth.dart';
class IMC {
  String peso;
  String status;
  String id;
  String altura;
  String data;

  final FirebaseAuth auth = FirebaseAuth.instance;

  IMC({
    required this.peso,
    required this.status,
    required this.id,
    required this.altura,
    required this.data
  });

  factory IMC.fromMap(Map<String, dynamic> map) {
    return IMC(
      id: map["id"] ?? '', // Use valor padrão se for nulo
      peso: map["peso"] ?? '', // Use valor padrão se for nulo
      status: map["status"] ?? '', // Use valor padrão se for nulo
      altura: map["altura"] ?? '',
      data: map["data"] ?? ""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "peso": peso,
      "status": status,
      "id": id,
      "altura": altura,
      "data" : data
    };
  }
}
