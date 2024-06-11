import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao/models/Consultas.dart';

class ListaConsultas extends StatefulWidget {
  final String idUsuario;
  const ListaConsultas({required this.idUsuario});

  @override
  State<ListaConsultas> createState() => _ListaConsultasState();
}

class _ListaConsultasState extends State<ListaConsultas> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> refresh() async {
    setState(() {});
  }

  void formularioConsulta({Consultas? model}) {
    String labelTitle = "Adicionar Consulta";
    final _formKey = GlobalKey<FormState>();
    TextEditingController especialidadeController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    TextEditingController horarioController = TextEditingController();
    TextEditingController resumoController = TextEditingController();
    TextEditingController retornoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Adicionar Consulta",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextFormField(
                      controller: especialidadeController,
                      decoration: InputDecoration(
                        labelText: "Especialidade",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(71, 146, 121, 0.612)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color.fromRGBO(71, 146, 121, 0.612),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a especialidade.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: dataController,
                      decoration: InputDecoration(
                        labelText: "Data",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(71, 146, 121, 0.612)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color.fromRGBO(71, 146, 121, 0.612),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a data.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: horarioController,
                      decoration: InputDecoration(
                        labelText: "Horário",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(71, 146, 121, 0.612)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color.fromRGBO(3, 8, 7, 0.612),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o horário.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: resumoController,
                      decoration: InputDecoration(
                        labelText: "Resumo da consulta",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(71, 146, 121, 0.612)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color.fromRGBO(71, 146, 121, 0.612),
                      style: TextStyle(color: Colors.black),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o resumo da consulta.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: retornoController,
                      decoration: InputDecoration(
                        labelText: "Retorno",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(71, 146, 121, 0.612)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      cursorColor: Color.fromRGBO(71, 146, 121, 0.612),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o retorno.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                              color: Color.fromRGBO(71, 146, 121, 0.819),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await firestore
                                  .collection("Usuários")
                                  .doc(widget.idUsuario)
                                  .collection('Consultas')
                                  .add({
                                "especialidade": especialidadeController.text,
                                "data": dataController.text,
                                "horario": horarioController.text,
                                "resumo": resumoController.text,
                                "retorno": retornoController.text,
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Salvar",
                            style: TextStyle(
                              color: Color.fromRGBO(71, 146, 121, 0.819),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Consultas Realizadas",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection("Usuários")
            .doc(widget.idUsuario)
            .collection('Medicamentos')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar os dados"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Sem consultas cadastradas"));
          }

          Map<String, List<Consultas>> consultasPorEspecialidade = {};
          snapshot.data!.docs.forEach((doc) {
            var data = doc.data();
            Consultas consulta = Consultas.fromMap(data);
            if (!consultasPorEspecialidade
                .containsKey(consulta.especialidade)) {
              consultasPorEspecialidade[consulta.especialidade] = [];
            }
            consultasPorEspecialidade[consulta.especialidade]!.add(consulta);
          });

          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              children: consultasPorEspecialidade.entries.map((entry) {
                return ExpansionTile(
                  title: ListTile(
                    title: Text(entry.key),
                  ),
                  children: entry.value.map((consulta) {
                    return ListTile(
                      title: Text("Data: ${consulta.data}"),
                      subtitle: Text(
                          "Horário: ${consulta.horario}\nResumo: ${consulta.resumo}\nRetorno: ${consulta.retorno}"),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: formularioConsulta,
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
    );
  }
}
