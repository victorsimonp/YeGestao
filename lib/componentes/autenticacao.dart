import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class autenticacao {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  cadastro({
     required String email,
    required String senha
  }) async {await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: senha);}
  }

