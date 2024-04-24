class Exame {
  final String? data;
  final String? nomeExame;

  Exame(this.data, this.nomeExame);

  @override
  String toString() {
    return 'Exame {data: $data, nome do exame: $nomeExame}';
  }
}
