import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:gestao/models/Glicemia.dart';

class ListaGlicemia extends StatefulWidget {
  final String idUsuario;
  const ListaGlicemia({required this.idUsuario});

  @override
  State<ListaGlicemia> createState() => _ListaGlicemiaState();
}

class _ListaGlicemiaState extends State<ListaGlicemia> {
  List<Glicemia> glicemiaAferida = [];
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
          "Glicemia",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) async {
              if (result == 'Editar') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Selecionar Glicemia para Editar',
                        style: TextStyle(fontSize: 20),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: glicemiaAferida.map((glicemia) {
                          return ListTile(
                            title:
                                Text('${glicemia.data} - ${glicemia.status}'),
                            onTap: () {
                              Navigator.pop(context);
                              formularioGlicemia(model: glicemia);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
                print('Editar');
              } else if (result == 'Excluir') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Selecionar Glicemia para Excluir'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: glicemiaAferida.map((glicemia) {
                          return ListTile(
                            title:
                                Text('${glicemia.data} - ${glicemia.status}'),
                            onTap: () {
                              Navigator.pop(context);
                              remover(glicemia);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
                print('Excluir');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Editar',
                child: Text('Editar'),
              ),
              const PopupMenuItem<String>(
                value: 'Excluir',
                child: Text('Excluir'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formularioGlicemia();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
      body: (glicemiaAferida.isEmpty)
          ? Center(
              child: Text("Nenhuma glicemia aferida encontrada"),
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
                              'Glicemia Aferida',
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
                    for (var glicemia in glicemiaAferida)
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(0xFFbec5c7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  glicemia.data,
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
                                  glicemia.status,
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
                                  _getGlicemiaStatus(glicemia.status),
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

  void formularioGlicemia({Glicemia? model}) {
    String labelTitle = "Adicionar Glicemia Aferida";
    String labelConfirmationButtom = "Salvar";
    String labelSkipButtom = "Cancelar";

    TextEditingController statusController = TextEditingController();
    TextEditingController dataController = TextEditingController();
    final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

    if (model != null) {
      labelTitle = "Editar Glicemia Aferida";
      statusController.text = model.status;
      dataController.text = model.data;
    }

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
                      decoration: const InputDecoration(
                        labelText: "Dia da Aferição da Glicemia",
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
                          return 'Por favor, insira a data da aferição.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: statusController,
                      decoration: const InputDecoration(
                        labelText: "Glicemia Aferida (ex:80)",
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
                          return 'Por favor, insira a glicemia aferida.';
                        }
                        final RegExp regex = RegExp(r'^\d{2,3}$');
                        if (!regex.hasMatch(value)) {
                          return 'Insira a glicemia no formato correto (ex: 80).';
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
                            labelSkipButtom,
                            style: TextStyle(
                                color: Color.fromRGBO(71, 146, 121, 0.819)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Se o formulário for válido, continue com a lógica
                              String glicemiaAferidaText =
                                  statusController.text;
                              String status =
                                  _determineGlicemiaStatus(glicemiaAferidaText);

                              Glicemia glicemia = Glicemia(
                                id: model?.id ?? const Uuid().v1(),
                                status: glicemiaAferidaText,
                                data: dataController.text,
                              );

                              try {
                                if (model != null) {
                                  // Verificar se o documento existe
                                  var docRef = firestore
                                      .collection('Usuários')
                                      .doc(widget.idUsuario)
                                      .collection('Glicemia')
                                      .doc(model.id);

                                  var docSnapshot = await docRef.get();
                                  if (docSnapshot.exists) {
                                    // Atualizar o documento existente
                                    print("Atualizando documento existente...");
                                    await docRef.update(glicemia.toMap());

                                    setState(() {
                                      int index = glicemiaAferida.indexWhere(
                                          (item) => item.id == model.id);
                                      if (index != -1) {
                                        glicemiaAferida[index] = glicemia;
                                      }
                                    });
                                  } else {
                                    print(
                                        "Documento não encontrado para atualização.");
                                    // Opcional: Adicionar lógica para lidar com documento não encontrado
                                  }
                                } else {
                                  // Adicionar um novo documento
                                  print("Adicionando novo documento...");
                                  var docRef = await firestore
                                      .collection('Usuários')
                                      .doc(widget.idUsuario)
                                      .collection('Glicemia')
                                      .add(glicemia.toMap());
                                  glicemia.id = docRef
                                      .id; // Atualizar o ID do objeto glicemia com o ID gerado pelo Firestore

                                  setState(() {
                                    glicemiaAferida.insert(0,
                                        glicemia); // Adicione ao início da lista
                                  });
                                }

                                Navigator.pop(context);
                              } catch (e) {
                                print("Erro ao salvar glicemia: $e");
                              }
                            }
                          },
                          child: Text(
                            labelConfirmationButtom,
                            style: TextStyle(
                                color: Color.fromRGBO(71, 146, 121, 0.819)),
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

  Future<void> refresh() async {
    print('Iniciando refresh...'); // Debug log
    List<Glicemia> temp = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("Usuários")
          .doc(widget.idUsuario)
          .collection('Glicemia')
          .orderBy('data',
              descending: true) // Ordene por data, mais recente primeiro
          .get();

      for (var doc in snapshot.docs) {
        print('Documento encontrado: ${doc.data()}'); // Debug log
        temp.add(Glicemia.fromMap(doc.data()));
      }

      setState(() {
        glicemiaAferida = temp;
      });
    } catch (e) {
      print('Erro ao recuperar dados: $e'); // Debug log
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

  String _getGlicemiaStatus(String glicemia) {
    return _determineGlicemiaStatus(glicemia);
  }

  void remover(Glicemia glicemia) async {
  try {
    print('Iniciando remoção do documento ${glicemia.id}');
    
    await firestore
        .collection('Glicemia')        
        .doc(glicemia.id)
        .delete();
    
    print('Documento ${glicemia.id} excluído com sucesso do banco de dados');

    setState(() {
      glicemiaAferida.removeWhere((p) => p.id == glicemia.id);
      print('Documento ${glicemia.id} removido da lista local');
    });
  } catch (e) {
    print("Erro ao excluir: $e");
  }
}

}
