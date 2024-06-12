import 'package:test/test.dart';
import 'package:gestao/models/Glicemia.dart';
import 'package:gestao/pages/listaGlicemia.dart';

void main() {
  group('Glicemia', () {
    test('Registrar aferição de glicemia', () {
      // Given
      var userEmail = 'ana@example.com';
      var status = "95";
      var id = "";
      var data = "12/06/2024";

      // When
      var glicemia = Glicemia(
        data: data,
        id: id,
        status: status
        
      );

      // Then
      expect(glicemia.status, status);
      expect(glicemia.data, data);
    });
  });
}
