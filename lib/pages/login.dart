import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestao/Usuario.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_email_validator/flutter_email_validator.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool queroEntrar = true;
  // controladores de campos
  TextEditingController controladorNome = TextEditingController();
  TextEditingController controladoremail = TextEditingController();
  TextEditingController controladorsenha = TextEditingController();
  final List<Usuario> listaUsuario = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "YE Gestão de Saúde",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(182, 249, 234, 0.855),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 2.0),
                    child: Form(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Image.asset(
                            "assets/Logo Escuro.png",
                            height: 250,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              controller: controladoremail,
                              decoration: InputDecoration(
                                  label: Text("E-mail",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 44, 44, 44))),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 44, 44, 44)))),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              controller: controladorsenha,
                              decoration: InputDecoration(
                                  label: Text(
                                    "Senha",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 44, 44, 44)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 44, 44, 44)))),
                              obscureText: true,
                            ),
                          ),
                          Visibility(
                              visible: !queroEntrar,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: TextFormField(
                                      controller: controladorNome,
                                      decoration: InputDecoration(
                                        label: Text(
                                          "Nome",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 44, 44, 44)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 44, 44, 44))),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, left: 10.0, right: 10.0),
                                      child: Theme(
                                        data: ThemeData(
                                            primaryColor:
                                                Color.fromARGB(255, 44, 44, 44),
                                            textTheme: TextTheme(
                                                bodyLarge: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 44, 44, 44)))),
                                        child: InputDatePickerFormField(
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          fieldLabelText:
                                              "Nascimento ( Mês/ Dia / Ano)",
                                        ),
                                      ))
                                ],
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromRGBO(71, 146, 121, 0.612)),
                                ),
                                child: Text(
                                  (queroEntrar) ? "Entrar" : "Cadastrar",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 44, 44, 44),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _logarComGoogle();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 240, 82, 82)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.google,
                                      color: Colors.white),
                                  SizedBox(width: 5),
                                  Text(
                                    "Entrar com o Google",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _logarComFacebook();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.facebook, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text(
                                    "Entrar com o Facebook",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () async {
                                setState(() {
                                  queroEntrar = !queroEntrar;
                                });

                                Usuario usuario = Usuario(
                                    id: const Uuid().v1(),
                                    nome: controladorNome.text,
                                    email: controladoremail.text,
                                    senha: controladorsenha.text);

                                // Verificar se os campos obrigatórios não estão vazios
                                if (usuario.nome.isNotEmpty &&
                                    usuario.email != null &&
                                    usuario.email!.isNotEmpty &&
                                    usuario.senha != null &&
                                    usuario.senha!.isNotEmpty) {
                                  try {
                                    // Salvar os dados do usuário no Firestore
                                    await firestore
                                        .collection("Usuários")
                                        .doc(usuario.id)
                                        .set(usuario.toMap());

                                    // Registrar o usuário no Firebase Authentication
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: usuario.email!,
                                            password: usuario.senha!);

                                    // O usuário foi registrado com sucesso
                                    print("Usuário cadastrado com sucesso!");

                                    // Agora você pode implementar o código de login aqui, se necessário
                                  } catch (e) {
                                    // Lidar com qualquer erro que possa ocorrer durante o cadastro ou registro
                                    print("Erro ao cadastrar o usuário: $e");
                                  }
                                } else {
                                  print(
                                      "Por favor, preencha todos os campos obrigatórios.");
                                }
                              },
                              child: Text(
                                (queroEntrar)
                                    ? "Ainda não tem conta? Cadastre-se!"
                                    : "Já tem conta? Entre!",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 44, 44, 44),
                                    fontSize: 20),
                              ))
                        ]))))));
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
      } else {}
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      } else {}
      return null;
    }
  }
}

Future<void> _logarComGoogle() async {
  final GoogleSignIn _logarComGoogle = GoogleSignIn();

  try {
    final GoogleSignInAccount? googleSignInAccount =
        await _logarComGoogle.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // final UserCredential userCredential =
      //     await _fi.signInWithCredential(credential);

      // // Navegue para a próxima tela após o login com sucesso
      // if (userCredential.user != null) {
      //   Navigator.pushNamed(context as BuildContext, "/home");
      // }
    }
  } catch (e) {}
}

Future<void> _logarComFacebook() async {
  try {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // Login com Facebook bem-sucedido, você pode prosseguir com o seu fluxo de autenticação aqui
      print('Login com Facebook bem-sucedido!');
    } else {
      // Login com Facebook falhou, trate de acordo
      print('Login com Facebook falhou: ${result.message}');
    }
  } catch (e) {
    // Trate quaisquer erros de exceção aqui
    print('Erro ao tentar fazer login com Facebook: $e');
  }
}
