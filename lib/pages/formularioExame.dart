import 'dart:io';
import 'package:gestao/componentes/Editor.dart';
import 'package:gestao/models/Exame.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FormularioExame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioExameState();
  }
}

class FormularioExameState extends State<FormularioExame> {
  File? _fotoSelecionada;

  Future _fotoCamera() async {
    final foto = await ImagePicker().pickImage(source: ImageSource.camera);
    if (foto == null) return;
    setState(() {
      _fotoSelecionada = File(foto.path);
    });
  }

  void selecionarArquivos() async {
    FilePickerResult? arquivoFinal = await FilePicker.platform.pickFiles();
    if (arquivoFinal != null) {
      PlatformFile file = arquivoFinal.files.first;
      print(file.name);
      print(file.bytes);
      print(file.extension);
      print(file.path);
    } else {}
  }

  final TextEditingController _controladorNomeExame = TextEditingController();
  final TextEditingController _controladorDataExame = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Adicionar Exame',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
       backgroundColor: Color.fromRGBO(182, 249, 234, 0.855),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                  controller: _controladorNomeExame,
                  decoration: InputDecoration(labelText: 'Nome Exame', hintText: 'Ex: Exame de Sangue'),
                  keyboardType: TextInputType.text,
                 ),
            ),
                
                
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                  controller: _controladorDataExame,
                  decoration: InputDecoration(labelText: "Data do Exame", hintText: "Ex: 24/04/2024", icon: Icon(Icons.calendar_today)),
                 ),
            ),
              SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    selecionarArquivos();
                  },
                  icon: Icon(Icons.attach_file),
                  tooltip: 'Selecionar Arquivo',
                ),
                IconButton(
                  onPressed: () {
                    _fotoCamera();
                  },
                  icon: Icon(Icons.camera_alt),
                  tooltip: 'Abrir Câmera',
                ),
              ],
            ),
            SizedBox(height: 340,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8),
              child: ElevatedButton(
                onPressed: () {
                  final String? nomeExame = _controladorNomeExame.text;
                  final String? data = _controladorDataExame.text;
                  if (nomeExame != null && data != null) {
                    final formularioCriado = Exame(nomeExame, data);
                    debugPrint('Histórico Exame');
                    debugPrint('$formularioCriado');
                    Navigator.pop(context, formularioCriado);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
                  padding: EdgeInsets.symmetric(
                      horizontal: 140.0,
                      vertical: 10.0),
                ),
                child: Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
