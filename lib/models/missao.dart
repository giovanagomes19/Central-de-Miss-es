class Missao {
  String? id;
  String titulo;
  String dificuldade;
  int pontos;
  bool concluida;

  Missao({
    this.id,
    required this.titulo,
    required this.dificuldade,
    required this.pontos,
    this.concluida = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'dificuldade': dificuldade,
      'pontos': pontos,
      'concluida': concluida,
    };
  }

  factory Missao.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return Missao(
      id: id,
      titulo: map['titulo'] ?? '',
      dificuldade: map['dificuldade'] ?? 'Fácil',
      pontos: map['pontos'] ?? 10,
      concluida: map['concluida'] ?? false,
    );
  }
}