class Usuario {
  String id;
  String nome;
  String? email; // Usando o operador ? para indicar que o email pode ser nulo
  String? senha; // Usando o operador ? para indicar que a senha pode ser nula

  Usuario({
    required this.id,
    required this.nome,
    this.email,
    this.senha,
  });

  // Adicionado método factory para criar um objeto Usuario a partir de um Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map["id"],
      nome: map["nome"],
      email: map["email"], // Pode ser nulo se não houver email no Map
      senha: map["senha"], // Pode ser nulo se não houver senha no Map
    );
  }

  // Método para converter um objeto Usuario em um Map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "email": email,
      "senha": senha,
    };
  }
}
