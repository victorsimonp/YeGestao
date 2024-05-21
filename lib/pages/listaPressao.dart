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
                      decoration: const InputDecoration(
                        labelText: "Dia da Aferição da Pressão",
                      ),
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
                      ),
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
                          child: Text(labelSkipButtom),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Se o formulário for válido, continue com a lógica
                              String pressaoAferidaText = statusController.text;
                              String status =
                                  _determinePressaoStatus(pressaoAferidaText);

                              Pressao pressao = Pressao(
                                id: const Uuid().v1(),
                                status: pressaoAferidaText,
                                data: dataController.text,
                              );

                              await firestore
                                  .collection('Usuários')
                                  .doc(widget.idUsuario)
                                  .collection('Pressão')
                                  .add(pressao.toMap());

                              setState(() {
                                pressaoAferida.insert(
                                    0, pressao); // Adicione ao início da lista
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: Text(labelConfirmationButtom),
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
    List<Pressao> temp = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("Usuários")
          .doc(widget.idUsuario)
          .collection('Pressão')
          .orderBy('data',
              descending: true) // Ordene por data, mais recente primeiro
          .get();

      for (var doc in snapshot.docs) {
        print('Documento encontrado: ${doc.data()}'); // Debug log
        temp.add(Pressao.fromMap(doc.data()));
      }

      setState(() {
        pressaoAferida = temp;
      });
    } catch (e) {
      print('Erro ao recuperar dados: $e'); // Debug log
    }
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

  String _getPressaoStatus(String pressao) {
    return _determinePressaoStatus(pressao);
  }
}
