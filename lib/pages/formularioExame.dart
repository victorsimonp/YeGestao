import 'package:gestao/componentes/Editor.dart';
import 'package:gestao/models/Exame.dart';
import 'package:flutter/material.dart';

class FormularioExame extends StatefulWidget {

@override
State<StatefulWidget> createState() {
  return FormularioExameState();
}
}

class FormularioExameState extends State<FormularioExame> {
  final TextEditingController _controladorNomeExame = TextEditingController();
  final TextEditingController _controladorDataExame = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Adicionar Exame',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
                controlador: _controladorNomeExame,
                dica: "Ex: Exame de Sangue",
                rotulo: 'Nome do Exame'),
            Editor(
                controlador: _controladorDataExame,
                dica: 'Ex: 24/04/2024',
                rotulo: 'Data do Exame',
                icone: Icons.calendar_today),
            ElevatedButton(
                onPressed: () {
                  final String? nomeExame =
                      (_controladorNomeExame.text);
                  final String? data =
                      (_controladorDataExame.text);
                  if (nomeExame != null && data != null) {
                    final formularioCriado =
                        Exame(nomeExame, data);
                    debugPrint('Histórico Exame');
                    debugPrint('$formularioCriado');
                    Navigator.pop(context, formularioCriado);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
                 
                ),
                child: Text('Confirmar', style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    );
  }
}