import 'package:flutter/material.dart';

class formularioIMC extends StatelessWidget {
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
            ),
            SizedBox(height: 20),
            UserInfoItem(
              title: 'Altura',
              date: '01/01/2024',
              value: '1.70 m',
            ),
            SizedBox(height: 20),
            UserInfoItem(
              title: 'IMC',
              date: '01/01/2024',
              value: '24.2',
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

  const UserInfoItem({
    Key? key,
    required this.title,
    required this.date,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Data: $date',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
