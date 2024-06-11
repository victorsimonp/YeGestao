import 'package:test/test.dart';
import 'package:gestao/models/Exame.dart';
import 'package:gestao/pages/formularioExame.dart';

void main() {
  group('Exam', () {
    test('Register exam successfully', () {
      // Given
      var userEmail = 'ana@example.com';
      var nomeExame = 'Hemograma';
      var data = '05/06/2024';
      var result = 'Normal';
      var arquivo = "exame.pdf";
      var imagem = true;
      var id = "";

      // When
      var exam = Exame(
        nomeExame: nomeExame,
        arquivo: arquivo,
        data: data,
        imagem: imagem,
        id: id,
      );

      // Then
      expect(exam.nomeExame, nomeExame);
      expect(exam.data, data);
      expect(exam.arquivo, arquivo);
      expect(exam.imagem, imagem);
      
    });
  });
}
