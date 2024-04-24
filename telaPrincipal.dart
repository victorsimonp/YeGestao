import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // Removendo o título da AppBar
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    20), // Adicionando espaçamento horizontal ao redor do corpo
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20), // Reduzi o espaçamento para 20 pixels
                Text(
                  'Lucas Giaquinto',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    height:
                        20), // Espaçamento adicional entre o nome e os botões
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 70, // Reduzi o espaço entre as linhas
                  crossAxisSpacing: 40, // Reduzi o espaço entre as colunas
                  padding: EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 10), // Reduzi o espaçamento interno
                  children: [
                    Column(
                      children: [
                        Text('Última aferição\n da pressão',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        _buildSquareButton('150x100 Alta\n'),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Última aferição\n de glicemia',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        _buildSquareButton('85mg/Dl Normal'),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Última aferição\n de peso e altura',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        _buildSquareButton('90kg 170 cm\n'),
                      ],
                    ),
                    Column(
                      children: [
                        Text('\nIMC',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        _buildSquareButton('31,14 Obesidade II'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomButton('Exames'),
              _buildBottomButton('Consultas'),
              _buildBottomButton('Medicação'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareButton(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff48ca8e),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10), // Adicionando preenchimento interno
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String title) {
    return Container(
      width: 120,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Color(0xff48ca8e),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
