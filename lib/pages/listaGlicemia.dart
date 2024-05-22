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

  void formularioGlicemia() {
    String labelTitle = "Adicionar Glicemia Aferida";
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
                      decoration: const InputDecoration(
                        labelText: "Dia da Aferição da Glicemia",
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
                          child: Text(labelSkipButtom, style: TextStyle(color: Color.fromRGBO(71, 146, 121, 0.819))),
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
                                id: const Uuid().v1(),
                                status: glicemiaAferidaText,
                                data: dataController.text,
                              );

                              await firestore
                                  .collection('Usuários')
                                  .doc(widget.idUsuario)
                                  .collection('Glicemia')
                                  .add(glicemia.toMap());

                              setState(() {
                                glicemiaAferida.insert(
                                    0, glicemia); // Adicione ao início da lista
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
}
