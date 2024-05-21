import 'package:gestao/models/Exame.dart';
import 'package:gestao/pages/formularioExame.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//fazer pegar dados do firebase
//corretamente pegar apenas pdf das imagens como nome do arquivo
//baixar arquivo no firestore
class ListaExame extends StatefulWidget {
  final String idUsuario;
  final List<Exame> _exames = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ListaExame({required this.idUsuario});

  @override
  State<StatefulWidget> createState() {
    return ListaExameState();
  }
}

class ListaExameState extends State<ListaExame> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Histórico de Exame',
          style: TextStyle(fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body:
      ListView.builder(

        itemCount: widget._exames.length,
        itemBuilder: (context, indice) {
          final exame = widget._exames[indice];
          return itemExame(exame);
        },
      ),
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
    ));
  }
}
