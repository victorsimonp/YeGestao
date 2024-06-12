import 'package:test/test.dart';
import 'package:gestao/models/Medicamentos.dart';
import 'package:gestao/pages/listaMedicamentos.dart'; 

void main() {
  group('Medicamentos', () {
    test('Registrar Medicamentos com sucesso', () {
      // Given
      var userEmail = 'ana@example.com';
      var medicamento = 'Paracetamol';
      var horario = '10:00';
      var periodo = "7 dias";
      var data = "12/06/2024";

      // When
      var medication = Medicamentos(
        nomeRemedio: medicamento,
        id: userEmail,
        periodo: periodo,
        horario: horario,
        data: data,
      );

      // Then
      expect(medication.nomeRemedio, medicamento);
      expect(medication.periodo, periodo);
      expect(medication.horario, horario);
      expect(medication.data, data);
    });
  });
}
