import 'package:gestao/models/Exame.dart';
import 'package:gestao/pages/formularioExame.dart';
import 'package:flutter/material.dart';

class ListaExame extends StatefulWidget {
  final List<Exame> _exames = [];

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
       
        title: const Text('Histórico de Exame',
          style: TextStyle(color: Colors.black,),),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        centerTitle: true,
      ),
       backgroundColor: Color.fromRGBO(182, 249, 234, 0.855),
      body: ListView.builder(
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
            return FormularioExame();
          }));
          future.then((exameRecebido) {
            Future.delayed(Duration(seconds: 1), (){
            debugPrint('chegou no then do future');
            debugPrint('$exameRecebido');
            setState(() {
              widget._exames.add(exameRecebido);
            });
              
            });
            
          });
        },
        child: Icon(Icons.add, color: Colors.black , ), backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
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