import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:gestao/componentes/Editor.dart';
import 'package:gestao/models/Exame.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestao/models/Usuario.dart';
import 'package:gestao/pages/login.dart';
import 'package:gestao/pages/listaExame.dart';
import 'package:permission_handler/permission_handler.dart';

class editarExame extends StatefulWidget {
  final String idUsuario;
  final Map exameAtual;
  editarExame({required this.idUsuario, required this.exameAtual});
  @override
  State<StatefulWidget> createState() {
    return editarExameState();
  }
}

class editarExameState extends State<editarExame> {
  File? _fotoSelecionada;
  var _arquivo;
  var _arquivoNome;
  var caminho;
  var tipoFile;

  Future _fotoCamera() async {
    final foto = await ImagePicker().pickImage(source: ImageSource.camera);
    if (foto == null) return;

    setState(() {
      _arquivo = File(foto.path);
      _arquivoNome = foto.name;
      tipoFile = true;
    });
  }

//sem permissão para pegar arquivos por enquanto, não funciona
  void selecionarArquivos() async {
    FilePickerResult? arquivoFinal = await FilePicker.platform.pickFiles();
    if (arquivoFinal != null) {
      PlatformFile file = arquivoFinal.files.first;
      print(file.name);
      print(file.bytes);
      print(file.extension);
      print(file.path);
      caminho = file.path;
      _arquivo = File(caminho);
      _arquivoNome = file.name;
      tipoFile = false;
    }
  }

  final TextEditingController _controladorNomeExame = TextEditingController();
  final TextEditingController _controladorDataExame = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> exame =
        widget.exameAtual.map((key, value) => MapEntry(key.toString(), value));
    String nomeOriginal = exame['nomeExame'];
    String dataOriginal = exame['data'];
    String arquivoOriginal = exame['arquivo'];
    bool tipoOriginal = exame['imagem'];
    String idExame = exame['id'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Editar exame',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controladorNomeExame,
                decoration: InputDecoration(
                    labelText: "Alterar nome do exame",
                    hintText: "Atual: $nomeOriginal"),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _controladorDataExame,
                decoration: InputDecoration(
                    labelText: "Alterar data do exame",
                    hintText: "Atual: $dataOriginal",
                    icon: Icon(Icons.calendar_today)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    selecionarArquivos();
                    File? foto = _fotoSelecionada;
                  },
                  icon: Icon(Icons.attach_file),
                  tooltip: 'Substituir por arquivo',
                ),
                IconButton(
                  onPressed: () {
                    _fotoCamera();
                  },
                  icon: Icon(Icons.camera_alt),
                  tooltip: 'Substituir por foto',
                ),
              ],
            ),
            SizedBox(
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8),
              child: ElevatedButton(
                onPressed: () async {
                  final String nome = _controladorNomeExame.text;
                  final String dia = _controladorDataExame.text;
                  final arquivoAtual = _arquivoNome;
                  final arquivo = _arquivo;
                  final exameEditado = Exame(
                      data: _controladorDataExame.text.isEmpty
                          ? dataOriginal
                          : dia,
                      nomeExame: _controladorNomeExame.text.isEmpty
                          ? nomeOriginal
                          : nome,
                      arquivo: (arquivoAtual == null)
                          ? arquivoOriginal
                          : arquivoAtual,
                      imagem: (tipoFile == null) ? tipoOriginal : tipoFile,
                      id: idExame);
                  firestore
                      .collection('Usuários')
                      .doc(widget.idUsuario)
                      .collection('Exames')
                      .doc(idExame)
                      .update(exameEditado.toMap());
                  debugPrint('Histórico Exame');
                  debugPrint('$exameEditado');
                  if (arquivoAtual != null) {
                    await storage.ref('Exames/$arquivoOriginal').delete();
                    final arquivoEnviado = storage.ref('Exames/$arquivoAtual');
                    await arquivoEnviado.putFile(arquivo);
                  }
                  Navigator.pop(context, exameEditado);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
                  padding:
                      EdgeInsets.symmetric(horizontal: 140.0, vertical: 10.0),
                ),
                child: Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      EdgeInsets.symmetric(horizontal: 156.0, vertical: 10.0),
                ),
                child: Text(
                  'Excluir',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
