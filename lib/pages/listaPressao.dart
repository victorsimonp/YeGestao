import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:gestao/models/Pressao.dart';

class ListaPressao extends StatefulWidget {
  final String idUsuario;
  const ListaPressao({required this.idUsuario});

  @override
  State<ListaPressao> createState() => _ListaPressaoState();
}

class _ListaPressaoState extends State<ListaPressao> {
  List<Pressao> pressaoAferida = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    refresh(); // Carregar os dados ao inicializar a página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Navega para a tela anterior
          },
        ),
        title: Text(
          "Pressão Arterial",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Editar') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Selecionar Pressão para Editar', style: TextStyle(fontSize: 20),),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: pressaoAferida.map((pressao) {
                          return ListTile(
                            title: Text('${pressao.data} - ${pressao.status}'),
                            onTap: () {
                              Navigator.pop(context);
                              editarPressao(pressao);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              } else if (value == 'Excluir') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Selecionar Pressão para Excluir'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: pressaoAferida.map((pressao) {
                          return ListTile(
                            title: Text('${pressao.data} - ${pressao.status}'),
                            onTap: () {
                              Navigator.pop(context);
                              excluirPressao(pressao);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Editar', 'Excluir'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formularioPressao();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
      body: (pressaoAferida.isEmpty)
          ? Center(
              child: Text("Nenhuma pressão aferida encontrada"),
            )
          : RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(100.0),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(100.0),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Color(0xFF7b8d93)),
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Data',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Pressão Aferida',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Status',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var pressao in pressaoAferida)
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(0xFFbec5c7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  pressao.data,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(0xFF7b8d93),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  pressao.status,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Color(0xFFbec5c7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _getPressaoStatus(pressao.status),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  void formularioPressao() {
    String labelTitle = "Adicionar Pressão Aferida";
    String labelConfirmationButtom = "Salvar";
    String labelSkipButtom = "Cancelar";

    TextEditingController statusController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que o conteúdo role quando o teclado aparece
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Ajusta o padding com base no teclado
          ),
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.6, // Reduz a altura do container
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(labelTitle,
                        style: Theme.of(context).textTheme.headline5),
                    TextFormField(
                      controller: dataController,
                      decoration: InputDecoration(
                        labelText: "Dia da Aferição da Pressão",
                        labelStyle: TextStyle(
                            color: Colors
                                .black), // Cor do label quando não está focado
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(71, 146, 121, 0.612)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .grey), // Cor da linha quando não está focado
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .red), // Cor da linha em caso de erro e focado
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.red), // Cor da linha em caso de erro
                        ),
                      ),
                      cursorColor:
                          Color.fromRGBO(71, 146, 121, 0.612), // Cor do cursor
                      style: TextStyle(color: Colors.black), // Cor do texto
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a data da aferição.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: statusController,
                      decoration: const InputDecoration(
                        labelText: "Pressão Aferida (ex: 120/80)",
                        labelStyle: TextStyle(
                            color: Colors
                                .black), // Cor do label quando não está focado
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(71, 146, 121, 0.612)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .grey), // Cor da linha quando não está focado
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .red), // Cor da linha em caso de erro e focado
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.red), // Cor da linha em caso de erro
                        ),
                      ),
                      cursorColor:
                          Color.fromRGBO(71, 146, 121, 0.612), // Cor do cursor
                      style: TextStyle(color: Colors.black), // Cor do texto
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a pressão aferida.';
                        }
                        final RegExp regex = RegExp(r'^\d{2,3}/\d{2,3}$');
                        if (!regex.hasMatch(value)) {
                          return 'Insira a pressão no formato correto (ex: 120/80).';
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
                          child: Text(labelSkipButtom,
                              style: TextStyle(
                                  color:
                                      Color.fromRGBO(71, 146, 121, 0.819))),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!
                                .validate()) {
                              // Valida o formulário
                              var id = Uuid().v4();
                              var novaPressao = Pressao(
                                id: id,
                                status: statusController.text,
                                data: dataController.text,
                              );
                              var pressaoAferidaText = statusController.text;
                              String status =
                                  _determinePressaoStatus(pressaoAferidaText);
                              novaPressao.status = pressaoAferidaText;

                              await firestore
                                  .collection('Usuários')
                                  .doc(widget.idUsuario)
                                  .collection('Pressão')
                                  .doc(id)
                                  .set(novaPressao.toMap());

                              setState(() {
                                pressaoAferida.add(novaPressao);
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: Text(labelConfirmationButtom,
                              style: TextStyle(
                                  color:
                                      Color.fromRGBO(71, 146, 121, 0.819))),
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

  Future<void> refresh() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('Usuários')
        .doc(widget.idUsuario)
        .collection('Pressão')
        .get();

    setState(() {
      pressaoAferida = snapshot.docs
          .map((doc) => Pressao.fromMap(doc.data()))
          .toList();
    });
  }

  String _getPressaoStatus(String pressao) {
    List<String> pressaoValues = pressao.split('/');
    int sistolica = int.tryParse(pressaoValues[0]) ?? 0;
    int diastolica = int.tryParse(pressaoValues[1]) ?? 0;

    if (sistolica < 90 || diastolica < 60) {
      return 'Baixa';
    } else if (sistolica > 140 || diastolica > 90) {
      return 'Alta';
    } else {
      return 'Normal';
    }
  }

  String _determinePressaoStatus(String pressao) {
    List<String> pressaoValues = pressao.split('/');
    int sistolica = int.tryParse(pressaoValues[0]) ?? 0;
    int diastolica = int.tryParse(pressaoValues[1]) ?? 0;

    if (sistolica < 90 || diastolica < 60) {
      return 'Baixa';
    } else if (sistolica > 140 || diastolica > 90) {
      return 'Alta';
    } else {
      return 'Normal';
    }
  }

  void editarPressao(Pressao pressao) {
    String labelTitle = "Editar Pressão Aferida";
    String labelConfirmationButtom = "Salvar";
    String labelSkipButtom = "Cancelar";

    TextEditingController statusController = TextEditingController(text: pressao.status);
    TextEditingController dataController = TextEditingController(text: pressao.data);
    final _formKey = GlobalKey<FormState>();

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
                    Text(labelTitle, style: Theme.of(context).textTheme.headline5),
                    TextFormField(
                      controller: dataController,
                      decoration: InputDecoration(
                        labelText: "Dia da Aferição da Pressão",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(71, 146, 121, 0.612)),
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
                          return 'Por favor, insira a data da aferição.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: statusController,
                      decoration: const InputDecoration(
                        labelText: "Pressão Aferida (ex: 120/80)",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(71, 146, 121, 0.612)),
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
                          return 'Por favor, insira a pressão aferida.';
                        }
                        final RegExp regex = RegExp(r'^\d{2,3}/\d{2,3}$');
                        if (!regex.hasMatch(value)) {
                          return 'Insira a pressão no formato correto (ex: 120/80).';
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
                          child: Text(labelSkipButtom, style: TextStyle(color: Color.fromRGBO(71, 146, 121, 0.819))),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String pressaoAferidaText = statusController.text;
                              String status = _determinePressaoStatus(pressaoAferidaText);

                              pressao.status = pressaoAferidaText;
                              pressao.data = dataController.text;

                              await firestore
                                  .collection('Usuários')
                                  .doc(widget.idUsuario)
                                  .collection('Pressão')
                                  .doc(pressao.id)
                                  .update(pressao.toMap());

                              setState(() {
                                pressaoAferida[pressaoAferida.indexWhere((p) => p.id == pressao.id)] = pressao;
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: Text(labelConfirmationButtom, style: TextStyle(color: Color.fromRGBO(71, 146, 121, 0.819))),
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

  void excluirPressao(Pressao pressao) async {
    await firestore
        .collection('Usuários')
        .doc(widget.idUsuario)
        .collection('Pressão')
        .doc(pressao.id)
        .delete();

    setState(() {
      pressaoAferida.removeWhere((p) => p.id == pressao.id);
    });
  }
}
