import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao/models/IMC.dart';

class ListaIMC extends StatefulWidget {
  final String idUsuario;
  const ListaIMC({required this.idUsuario});

  @override
  State<ListaIMC> createState() => _ListaIMCState();
}

class _ListaIMCState extends State<ListaIMC> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> refresh() async {
    setState(() {});
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          "IMC",
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
            .collection('IMC')
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
            return Center(child: Text("Nenhuma medida aferida encontrada"));
          }

          var imcList = snapshot.data!.docs.map((doc) {
            var data = doc.data();
            IMC imc = IMC.fromMap(data);
            double peso = double.parse(imc.peso);
            double altura = double.parse(imc.altura);
            double imcValue = peso / ((altura / 100) * (altura / 100));
            String imcFormatted = imcValue.toStringAsFixed(1).substring(0, 2);
            return {
              'data': imc.data,
              'valorIMC': imcFormatted,
              'status': imc.status,
            };
          }).toList();

          return RefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(100.0),
                  1: FixedColumnWidth(160.0),
                  2: FlexColumnWidth(),
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
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Valor IMC',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
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
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var imc in imcList)
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            color: Color(0xFFbec5c7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                imc['data']??"",
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
                                imc['valorIMC']??"",
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
                                imc['status']??"",
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
          );
        },
      ),
    );
  }
}
