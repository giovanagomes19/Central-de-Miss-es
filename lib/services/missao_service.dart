import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/missao.dart';

class MissaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _colecao = 'missoes';

  Future<void> adicionar(Missao missao) async {
    await _firestore.collection(_colecao).add(
          missao.toMap(),
        );
  }

  Future<List<Missao>> buscarTodas() async {
    final resultado = await _firestore
        .collection(_colecao)
        .get();

    return resultado.docs.map((documento) {
      return Missao.fromMap(
        documento.data(),
        documento.id,
      );
    }).toList();
  }

  Future<void> atualizar(Missao missao) async {
    if (missao.id == null) return;

    await _firestore
        .collection(_colecao)
        .doc(missao.id)
        .update(
          missao.toMap(),
        );
  }

  Future<void> excluir(String id) async {
    await _firestore
        .collection(_colecao)
        .doc(id)
        .delete();
  }
}