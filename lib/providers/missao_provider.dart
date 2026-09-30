import 'package:flutter/material.dart';

import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService _service = MissaoService();

  List<Missao> _missoes = [];

  bool _carregando = false;

  List<Missao> get missoes => _missoes;

  bool get carregando => _carregando;

  int get pontosConquistados {
    int total = 0;

    for (final missao in _missoes) {
      if (missao.concluida) {
        total += missao.pontos;
      }
    }

    return total;
  }

  Future<void> carregarMissoes() async {
    _carregando = true;
    notifyListeners();

    try {
      _missoes = await _service.buscarTodas();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> adicionarMissao(Missao missao) async {
    await _service.adicionar(missao);
    await carregarMissoes();
  }

  Future<void> concluirMissao(Missao missao) async {
    missao.concluida = true;

    await _service.atualizar(missao);
    await carregarMissoes();
  }

  Future<void> excluirMissao(String id) async {
    await _service.excluir(id);
    await carregarMissoes();
  }
}