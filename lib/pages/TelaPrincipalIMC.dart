import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: UserInfoScreen(),
  ));
}

class UserInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações do Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserInfoItem(
              title: 'Peso',
              date: '01/01/2024',
              value: '70 kg',
              backgroundColor: Color(0xff07a676),
            ),
            SizedBox(height: 20),
            UserInfoItem(
              title: 'Altura',
              date: '01/01/2024',
              value: '1.70 m',
              backgroundColor: Color(0xff07a676),
            ),
            SizedBox(height: 20),
            UserInfoItem(
              title: 'IMC',
              date: '01/01/2024',
              value: '24.2',
              backgroundColor: Color(0xff07a676),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String title;
  final String date;
  final String value;
  final Color backgroundColor;

  const UserInfoItem({
    Key? key,
    required this.title,
    required this.date,
    required this.value,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Data:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '$title:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}