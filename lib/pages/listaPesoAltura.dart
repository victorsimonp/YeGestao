import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:gestao/models/IMC.dart';

class ListaPesoAltura extends StatefulWidget {
  final String idUsuario;
  const ListaPesoAltura({required this.idUsuario});

  @override
  State<ListaPesoAltura> createState() => _ListaPesoAlturaState();
}

class _ListaPesoAlturaState extends State<ListaPesoAltura> {
  List<IMC> IMCAferido = [];
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
          "Medidas",
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
                      title: Text('Selecionar IMC para Editar'),
                      content:
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: firestore
                            .collection("Usuários")
                            .doc(widget.idUsuario)
                            .collection('IMC')
                            .orderBy('data', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Erro ao carregar os dados"));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                                child:
                                    Text("Nenhuma medida aferida encontrada"));
                          }

                          var imcList = snapshot.data!.docs.map((doc) {
                            var data = doc.data();
                            return IMC.fromMap(data);
                          }).toList();

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: imcList.map((imc) {
                              return ListTile(
                                title: Text('${imc.data} - ${imc.peso}kg - ${imc.altura}cm'),
                                onTap: () {
                                  Navigator.pop(context);
                                  formularioIMC(model: imc);
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    );
                  },
                );
              } else if (value == 'Excluir') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Selecionar IMC para Excluir'),
                      content:
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: firestore
                            .collection("Usuários")
                            .doc(widget.idUsuario)
                            .collection('IMC')
                            .orderBy('data', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Erro ao carregar os dados"));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                                child:
                                    Text("Nenhuma medida aferida encontrada"));
                          }

                          var imcList = snapshot.data!.docs.map((doc) {
                            var data = doc.data();
                            return IMC.fromMap(data);
                          }).toList();

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: imcList.map((imc) {
                              return ListTile(
                                title: Text('${imc.data} - ${imc.peso}kg - ${imc.altura}cm'),
                                onTap: () {
                                  Navigator.pop(context);
                                  excluirIMC(imc);
                                },
                              );
                            }).toList(),
                          );
                        },
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
          formularioIMC();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
      body: (IMCAferido.isEmpty)
          ? Center(
              child: Text("Nenhuma medida aferida encontrada"),
            )
          : RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(100.0),
                    1: FixedColumnWidth(
                        160.0), // Reduzindo a largura da coluna Altura
                    2: FlexColumnWidth(), // A coluna Status agora terá mais espaço
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
                              'Peso',
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
                              'Altura',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var imc in IMCAferido)
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              color: Color(0xFFbec5c7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  imc.data,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
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
                                  imc.peso,
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
                                  imc.altura,
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

  void formularioIMC({IMC? model}) {
    String labelTitle = "Adicionar IMC";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController dataController = TextEditingController();
    TextEditingController pesoController = TextEditingController();
    TextEditingController alturaController = TextEditingController();
    final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

    if (model != null) {
      labelTitle = "Editar Peso e Altura";
      dataController.text = model.data;
      pesoController.text = model.peso;
      alturaController.text = model.altura;
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
                        labelText: "Data da Verificação do IMC",
                        hintText: "Ex: 25/09/2024",
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
                          return 'Por favor, insira a data.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: pesoController,
                      decoration: const InputDecoration(
                        labelText: "Peso em Kg",
                        hintText: "80",
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o peso.';
                        }
                        final num? peso = num.tryParse(value);
                        if (peso == null || peso <= 0) {
                          return 'Insira um peso válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: alturaController,
                      decoration: const InputDecoration(
                        labelText: "Altura em Cm",
                        hintText: "Ex: 180",
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a altura.';
                        }
                        final num? altura = num.tryParse(value);
                        if (altura == null || altura <= 0) {
                          return 'Insira uma altura válida.';
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
                          child: Text(labelSkipButton,
                              style: TextStyle(
                                  color: Color.fromRGBO(71, 146, 121, 0.819))),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Se o formulário for válido, continue com a lógica
                              String data = dataController.text;
                              String peso = pesoController.text;
                              String altura = alturaController.text;

                              // Convertendo altura para metros
                              double alturaMetros = double.parse(altura) / 100;

                              IMC imc = IMC(
                                  id: const Uuid().v1(),
                                  data: data,
                                  peso: peso,
                                  altura: alturaMetros.toString(),
                                  status: _determineIMCStatus(
                                      peso, alturaMetros.toString()));

                              try {
                                if (model != null) {
                                  var docRef = firestore
                                      .collection("Usuários")
                                      .doc(widget.idUsuario)
                                      .collection("IMC")
                                      .doc(model.id);

                                  var docSnapshot = await docRef.get();
                                  if (docSnapshot.exists) {
                                    print("Atualizando documento existente...");
                                    await docRef.update(imc.toMap());

                                    setState(() {
                                      int index = IMCAferido.indexWhere(
                                          (item) => item.id == model.id);
                                      if (index != -1) {
                                        IMCAferido[index] = imc;
                                      }
                                    });
                                  } else {
                                    "Documento não encontrado";
                                  }
                                } else {
                                  print("Adicionando novo documento...");
                                  var docRef = await firestore
                                      .collection('Usuários')
                                      .doc(widget.idUsuario)
                                      .collection('IMC')
                                      .add(imc.toMap());
                                  imc.id = docRef
                                      .id; // Atualizar o ID do objeto glicemia com o ID gerado pelo Firestore

                                  setState(() {
                                    IMCAferido.insert(
                                        0, imc); // Adicione ao início da lista
                                  });
                                }
                                Navigator.pop(context);
                              } catch (e) {
                                print("Erro ao salvar glicemia: $e");
                              }
                            }
                          },
                          child: Text(labelConfirmationButton,
                              style: TextStyle(
                                  color: Color.fromRGBO(71, 146, 121, 0.819))),
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
    List<IMC> temp = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("Usuários")
          .doc(widget.idUsuario)
          .collection('IMC')
          .orderBy('data',
              descending: true) // Ordene por data, mais recente primeiro
          .get();

      for (var doc in snapshot.docs) {
        print('Documento encontrado: ${doc.data()}'); // Debug log
        temp.add(IMC.fromMap(doc.data()));
      }

      setState(() {
        IMCAferido = temp;
      });
    } catch (e) {
      print('Erro ao recuperar dados: $e'); // Debug log
    }
  }

  String _determineIMCStatus(String peso, String altura) {
    double pesoValue = double.tryParse(peso) ?? 0;
    double alturaValue = double.tryParse(altura) ?? 0;

    if (alturaValue <= 0 || pesoValue <= 0) {
      return "Desconhecido";
    }

    double imc = pesoValue / (alturaValue * alturaValue);

    if (imc < 18.5) {
      return "Magro ou baixo peso";
    } else if (imc < 24.9) {
      return "Normal";
    } else if (imc < 29.9) {
      return "Sobrepeso";
    } else if (imc < 34.9) {
      return "Obesidade 1";
    } else if (imc < 39.9) {
      return "Obesidade 2";
    } else {
      return "Obesidade grave";
    }
  }

  String _getIMCStatus(String peso, String altura) {
    return _determineIMCStatus(peso, altura);
  }

  Future<void> editarIMC(IMC imc) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar IMC'),
        content: Text('Tem certeza que deseja editar este registro de IMC?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              formularioEditarIMC(imc);
            },
            child: Text('Editar'),
          ),
        ],
      ),
    );
  }

  void formularioEditarIMC(IMC imc) {
    String labelTitle = "Editar IMC";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController dataController =
        TextEditingController(text: imc.data);
    TextEditingController pesoController =
        TextEditingController(text: imc.peso);
    TextEditingController alturaController =
        TextEditingController(text: imc.altura);

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
                    Text(labelTitle,
                        style: Theme.of(context).textTheme.headline5),
                    TextFormField(
                      controller: dataController,
                      decoration: const InputDecoration(
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
                      controller: pesoController,
                      decoration: const InputDecoration(
                        labelText: "Peso (kg)",
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o peso.';
                        }
                        final num? peso = num.tryParse(value);
                        if (peso == null || peso <= 0) {
                          return 'Insira um peso válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: alturaController,
                      decoration: const InputDecoration(
                        labelText: "Altura (cm)",
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a altura.';
                        }
                        final num? altura = num.tryParse(value);
                        if (altura == null || altura <= 0) {
                          return 'Insira uma altura válida.';
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
                          child: Text(labelSkipButton,
                              style: TextStyle(
                                  color: Color.fromRGBO(71, 146, 121, 0.819))),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String data = dataController.text;
                              String peso = pesoController.text;
                              String altura = alturaController.text;

                              double alturaMetros = double.parse(altura) / 100;

                              IMC novoIMC = IMC(
                                id: imc.id,
                                data: data,
                                peso: peso,
                                altura: alturaMetros.toString(),
                                status: _determineIMCStatus(
                                    peso, alturaMetros.toString()),
                              );

                              await firestore
                                  .collection('Usuários')
                                  .doc(widget.idUsuario)
                                  .collection('IMC')
                                  .doc(imc.id)
                                  .update(novoIMC.toMap());

                              setState(() {
                                int index = IMCAferido.indexWhere(
                                    (element) => element.id == imc.id);
                                IMCAferido[index] = novoIMC;
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: Text(labelConfirmationButton,
                              style: TextStyle(
                                  color: Color.fromRGBO(71, 146, 121, 0.819))),
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



  Future<void> excluirIMC(IMC imc) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir IMC'),
        content: Text('Tem certeza que deseja excluir este registro de IMC?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await firestore
                  .collection('Usuários')
                  .doc(widget.idUsuario)
                  .collection('IMC')
                  .doc(imc.id)
                  .delete();

              setState(() {
                IMCAferido.removeWhere((element) => element.id == imc.id);
              });

              Navigator.pop(context);
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
