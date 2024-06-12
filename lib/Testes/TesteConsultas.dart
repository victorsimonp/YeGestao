import 'package:test/test.dart';
import 'package:gestao/models/Consultas.dart';
import 'package:gestao/pages/listaConsultas.dart';

void main() {
  group('Consultas', () {
    test('Registrar Consultas com sucesso', () {
      // Given
      var userEmail = 'ana@example.com';
      var especialidade = 'Clínico Geral';
      var data = '12/06/2024';
      var horario = '14:00';
      var retorno = "12/07/2024";
      var id = "";
      var resumo = "Consulta foi muito boa e o médico pediu vários exames";

      // When
      var consultas = Consultas(
        especialidade: especialidade,
        horario: horario,
        data: data,
        retorno: retorno,
        id: id,
        resumo: resumo,
      );

      // Then
      expect(consultas.especialidade, especialidade);
      expect(consultas.horario, horario);
      expect(consultas.data, data);
      expect(consultas.retorno, retorno);
      expect(consultas.resumo, resumo);
    });
  });
}
