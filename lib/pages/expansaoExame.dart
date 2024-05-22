import 'package:flutter/material.dart';
import 'package:gestao/models/Exame.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ExpansaoExame extends StatefulWidget {
  final Exame exameAtual;

  const ExpansaoExame({required this.exameAtual});
  @override
  State<StatefulWidget> createState() => expansaoExameState();
}

class expansaoExameState extends State<ExpansaoExame> {
  var teste;

  @override
  Widget build(BuildContext context) {
    Map teste = widget.exameAtual.toMap();
    String nome = teste['nomeExame'];
    String URL;
    Future<String> downloadURLExample() async {
      var URL = await FirebaseStorage.instance
          .ref()
          .child("Flutter.png")
          .getDownloadURL();
      return URL;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          nome,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
        centerTitle: true,
      ),
      body: 
      FutureBuilder(
          future: FirebaseStorage.instance
              .ref()
              .child('Exames')
              .child(teste['arquivo'])
              .getDownloadURL(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('');
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  print(snapshot.data);
                  print('^aqui^');
                  String? imagem = snapshot.data;
                  return InteractiveViewer(
                    panEnabled: false, // Set it to false
                    boundaryMargin: EdgeInsets.all(100),
                    minScale: 0.5,
                    maxScale: 2,
                    child: Image.network(
                      imagem!,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  );
                }
            }
          }),
    );
  }
}