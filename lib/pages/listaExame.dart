import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestao/models/Exame.dart';
import 'package:gestao/pages/exapansaoExame.dart';
import 'package:gestao/pages/formularioExame.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

//fazer pegar dados do firebase
//corretamente pegar apenas pdf das imagens como nome do arquivo
//baixar arquivo no firestore
class ListaExame extends StatefulWidget {
  final String idUsuario;
  final List<Exame> _exames = [];

  ListaExame({required this.idUsuario});

  @override
  State<StatefulWidget> createState() {
    return ListaExameState();
  }
}

class ListaExameState extends State<ListaExame> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference exames;

  @override
  void initState() {
    super.initState();
    exames = firestore
        .collection('Usuários')
        .doc(widget.idUsuario)
        .collection('Exames');
  }

  Widget build(BuildContext context) {
    int quantia;
    var idAtual = widget.idUsuario;

    var exames = firestore.collection('Usuário/$idAtual/Exames');

    final CollectionReference<Map<String, dynamic>> examesAtuais = exames;

    var docs = exames.get();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Histórico de Exame',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<QuerySnapshot>(
          future: firestore
              .collection('Usuários')
              .doc(widget.idUsuario)
              .collection('Exames')
              .get(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('');
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  QuerySnapshot? querySnapshot = snapshot.data;
                  final todosExames =
                      querySnapshot!.docs.map((doc) => doc.data()).toList();
                  for (var i in todosExames) {
                    var data = Map<String, dynamic>.from(i as Map);
                    var membro = Exame.fromMap(data);
                    widget._exames.add(membro);
                  }
                  ;
                  return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, indice) {
                      final exame = widget._exames[indice];
                      return itemExame(exame);
                    },
                  );
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<dynamic> future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioExame(
              idUsuario: widget.idUsuario,
            );
          }));
          future.then((exameRecebido) {
            Future.delayed(Duration(seconds: 1), () {
              debugPrint('chegou no then do future');
              debugPrint('$exameRecebido');
              setState(() {
                widget._exames.add(exameRecebido);
              });
            });
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
    );
  }
}

class itemExame extends StatelessWidget {
  final Exame _exame;

  itemExame(this._exame);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Icon(Icons.medication),
      title: Text(_exame.data.toString()),
      subtitle: Text(_exame.nomeExame.toString()),
      //testando se ta arquivando corretamente as informações
      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => ExpansaoExame(exameAtual: _exame))),
    )
    );

  }
}