import 'package:test/test.dart';
import 'package:gestao/models/IMC.dart';
import 'package:gestao/pages/listaIMC.dart';


void main() {
  group('IMC', () {
    test('Calcular IMC corretamente', () {
      // Given
      var peso = "70";
      var altura = "175";
      var data = "12/06/2024";
      var id = "";
      var status = "22.9";

      // When
      var imc = IMC(
        altura: altura,
        peso: peso,
        data: data,
        id:id,
        status: status,
        
        
        
        );

      // Then
      expect(imc.status, status); 
    });
  });
}
