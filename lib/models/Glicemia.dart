import 'package:firebase_auth/firebase_auth.dart';
class Glicemia {
  String data;
  String status;
  String id;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Glicemia({
    required this.data,
    required this.status,
    required this.id,
  });

  factory Glicemia.fromMap(Map<String, dynamic> map) {
    return Glicemia(
      id: map["id"] ?? '', // Use valor padrão se for nulo
      data: map["data"] ?? '', // Use valor padrão se for nulo
      status: map["status"] ?? '', // Use valor padrão se for nulo
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "data": data,
      "status": status,
      "id": id,
    };
  }
}
