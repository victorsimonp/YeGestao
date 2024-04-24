import 'package:gestao/models/Exame.dart';
import 'package:gestao/pages/formularioExame.dart';
import 'package:flutter/material.dart';

class ListaExame extends StatefulWidget {
  final List<Exame> _transferencias = [];

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
          style: TextStyle(color: Colors.white,),),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTrasferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<dynamic> future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioExame();
          }));
          future.then((transferenciaRecebida) {
            Future.delayed(Duration(seconds: 1), (){
            debugPrint('chegou no then do future');
            debugPrint('$transferenciaRecebida');
            setState(() {
              widget._transferencias.add(transferenciaRecebida);
            });
              
            });
            
          });
        },
        child: Icon(Icons.add, color: Colors.white , ), backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
    );
  }
}

class ItemTrasferencia extends StatelessWidget {
  final Exame _transferencia;

  ItemTrasferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Icon(Icons.medication),
      title: Text(_transferencia.data.toString()),
      subtitle: Text(_transferencia.nomeExame.toString()),
    ));
  }
}