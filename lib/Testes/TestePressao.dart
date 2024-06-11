import 'package:test/test.dart';
import 'package:gestao/pages/listaPressao.dart';
import 'package:gestao/models/Pressao.dart';

void main() {
  group('Pressao', () {
    test('Registrar pressão aferida com sucesso', () {
      // Given
      var userEmail = 'ana@example.com';
      var status = "120/80";
      var data = "12/06/2024";
      var id = "";

      // When
      var pressaoAferida = Pressao(
        data: data,
        id: id,
        status: status,
        
      );

      // Then
      expect(pressaoAferida.data, data);      
      expect(pressaoAferida.status, status);
    });
  });
}
