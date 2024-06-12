import 'package:flutter/material.dart';

class SobreNosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AppBar(
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
              "YE Gestão de Saúde",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(71, 146, 121, 0.612),
          ),
          Expanded(
            child: Center(
              child: Container(
                color: Color.fromRGBO(71, 146, 121, 0.612),
                width: 300, // Largura do quadrado
                height: 500, // Altura do quadrado
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          'Nós somos o Minha Saúde em Dia, um aplicativo desenvolvido para melhorar a gestão da sua própria saúde e melhorar sua qualidade de vida.\n\n'
                          'Nele você pode colocar lembretes de suas consultas, colocar um resumo delas, definir os horários de suas medicações com apenas quatro informações, organizar os resultados de seus exames, como armazenar uma cópia deles e muito mais.',
                          style:
                              TextStyle(fontSize: 19, color: Color(0xff000000)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Sua saúde em suas mãos!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
