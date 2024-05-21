import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao/models/Exame.dart';
import 'package:gestao/pages/TelaPrincipalIMC.dart';
import 'package:gestao/pages/formularioExame.dart';
import 'package:gestao/pages/formularioIMC.dart';
import 'package:gestao/pages/listaExame.dart';
import 'package:gestao/pages/listaGlicemia.dart';
import 'package:gestao/pages/listaPressao.dart';
import 'package:gestao/pages/login.dart';

class TelaPrincipal extends StatelessWidget {
  final String nome;
  final String idUsuario;
  final List<Exame> examesUsuario = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TelaPrincipal({required this.nome, required this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "YE Gestão de Saúde",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '$nome',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildInfoCard(
                      context,
                      title: 'Última aferição de Pressão',
                      value: '150x100\nAlta',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListaPressao(idUsuario: idUsuario)),
                        );
                      },
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Última aferição de Glicemia',
                      value: '85mg/Dl\nNormal',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListaGlicemia(idUsuario: idUsuario)),
                        );
                      },
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Última verificação de peso e altura',
                      value: '90kg 170cm',
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TelaIMC()),
                        );
                      },
                    ),
                    _buildInfoCard(
                      context,
                      title: 'IMC',
                      value: '31,14\nObesidade II',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  formularioIMC()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildButtonCard(
                      context,
                      title: 'Exames',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListaExame(idUsuario: idUsuario)),
                        );
                      },
                    ),
                    _buildButtonCard(
                      context,
                      title: 'Consultas',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListaGlicemia(idUsuario: idUsuario)),
                        );
                      },
                    ),
                    _buildButtonCard(
                      context,
                      title: 'Medicação',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListaPressao(idUsuario: idUsuario)),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Padding(                  
                  padding: EdgeInsets.only(left: 260, bottom: 50),
                  child: TextButton(
                    onPressed: () {
                      // Adicione a navegação para a tela "Sobre nós", se necessário.
                    },
                    child: Text(
                      'Sobre nós',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),

              ],
            ),
          ),
          
        ),
        ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Spacer(),
              Text(
                value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonCard(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 25,), // Diminua o padding superior e inferior
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
