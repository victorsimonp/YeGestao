import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao/models/Exame.dart';
import 'package:gestao/models/IMC.dart';
import 'package:gestao/models/Glicemia.dart';
import 'package:gestao/pages/TelaPrincipalIMC.dart';
import 'package:gestao/pages/formularioExame.dart';
import 'package:gestao/pages/formularioIMC.dart';
import 'package:gestao/pages/listaExame.dart';
import 'package:gestao/pages/listaGlicemia.dart';
import 'package:gestao/pages/listaIMC.dart';
import 'package:gestao/pages/listaPesoAltura.dart';
import 'package:gestao/pages/listaPressao.dart';
import 'package:gestao/pages/login.dart';
import 'package:gestao/models/Pressao.dart'; // Certifique-se de que este caminho está correto

class TelaPrincipal extends StatefulWidget {
  final String nome;
  final String idUsuario;

  TelaPrincipal({required this.nome, required this.idUsuario});

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                  '${widget.nome}',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firestore
                          .collection("Usuários")
                          .doc(widget.idUsuario)
                          .collection('Pressão')
                          .orderBy('data', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Pressão',
                            value: 'Erro ao carregar',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaPressao(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Pressão',
                            value: 'Carregando...',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaPressao(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          var doc = snapshot.data!.docs.first.data();
                          Pressao pressao = Pressao.fromMap(doc);
                          String statusPressao =
                              _determinePressaoStatus(pressao.status);
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Pressão',
                            value: '${pressao.status}\n$statusPressao',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaPressao(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        } else {
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Pressão',
                            value: ' ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaPressao(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firestore
                          .collection("Usuários")
                          .doc(widget.idUsuario)
                          .collection('Glicemia')
                          .orderBy('data', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Glicemia',
                            value: 'Erro ao carregar',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaGlicemia(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Glicemia',
                            value: '',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaGlicemia(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          var doc = snapshot.data!.docs.first.data();
                          Glicemia glicemia = Glicemia.fromMap(doc);
                          String statusGlicemia =
                              _determineGlicemiaStatus(glicemia.status);
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Glicemia',
                            value: '${glicemia.status}\n$statusGlicemia',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaGlicemia(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        } else {
                          return _buildInfoCard(
                            context,
                            title: 'Última aferição de Glicemia',
                            value: ' ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListaGlicemia(
                                        idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firestore
                          .collection("Usuários")
                          .doc(widget.idUsuario)
                          .collection('IMC')
                          .orderBy('data', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _buildInfoCard(
                            context,
                            title: 'Última verificação de peso e altura',
                            value: 'Erro ao carregar',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaPesoAltura(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildInfoCard(
                            context,
                            title: 'Última verificação de peso e altura',
                            value: '',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaPesoAltura(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          var doc = snapshot.data!.docs.first.data();
                          IMC imc = IMC.fromMap(doc);
                          return _buildInfoCard(
                            context,
                            title: 'Verificação de peso e altura',
                            value: '${imc.peso} kg \n${imc.altura} cm',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaPesoAltura(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        } else {
                          return _buildInfoCard(
                            context,
                            title: 'Última verificação de peso e altura',
                            value: ' ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaPesoAltura(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firestore
                          .collection("Usuários")
                          .doc(widget.idUsuario)
                          .collection('IMC')
                          .orderBy('data', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _buildInfoCard(
                            context,
                            title: 'IMC',
                            value: 'Erro ao carregar',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaIMC(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildInfoCard(
                            context,
                            title: 'IMC',
                            value: 'Carregando...',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaIMC(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          var doc = snapshot.data!.docs.first.data();
                          IMC imc = IMC.fromMap(doc);
                          double peso = double.parse(imc.peso);
                          double altura = double.parse(imc.altura);
                          double imcValue =
                              peso / ((altura / 100) * (altura / 100));
                          String imcFormatted = imcValue.toStringAsFixed(1).substring(0, 2);
                          return _buildInfoCard(
                            context,
                            title: 'IMC',
                            value:
                                '$imcFormatted\n${imc.status}',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaIMC(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        } else {
                          return _buildInfoCard(
                            context,
                            title: 'IMC',
                            value: ' ',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListaIMC(idUsuario: widget.idUsuario)),
                              );
                            },
                          );
                        }
                      },
                    )
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
                                  ListaExame(idUsuario: widget.idUsuario)),
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
                                  ListaGlicemia(idUsuario: widget.idUsuario)),
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
                                  ListaPressao(idUsuario: widget.idUsuario)),
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

  String _determinePressaoStatus(String pressao) {
    final parts = pressao.split('/');
    if (parts.length != 2) return "Formato inválido";

    final sistolica = int.tryParse(parts[0]) ?? 0;
    final diastolica = int.tryParse(parts[1]) ?? 0;

    if (sistolica < 90 && diastolica < 60) {
      return "Baixa";
    } else if (sistolica < 120 && diastolica < 80) {
      return "Ótima";
    } else if (sistolica <= 129 && diastolica <= 84) {
      return "Normal";
    } else if (sistolica <= 139 && diastolica <= 89) {
      return "Atenção";
    } else if (sistolica >= 140 || diastolica >= 90) {
      return "Alta";
    } else {
      return "Desconhecido";
    }
  }

  String _determineGlicemiaStatus(String glicemia) {
    int glicemiaValue = int.tryParse(glicemia) ?? 0;

    if (glicemiaValue < 70) {
      return "Baixa";
    } else if (glicemiaValue < 100) {
      return "Normal";
    } else if (glicemiaValue >= 100 && glicemiaValue <= 126) {
      return "Atenção";
    } else if (glicemiaValue > 126) {
      return "Alta";
    } else {
      return "Desconhecido";
    }
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required String value,
      required VoidCallback onTap}) {
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
              blurRadius: 10,
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
        padding: const EdgeInsets.only(
          top: 25,
          bottom: 25,
        ), // Diminua o padding superior e inferior
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
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
