import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/missao.dart';
import '../providers/missao_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _tituloController = TextEditingController();

  String _dificuldadeSelecionada = 'Fácil';

  @override
void initState() {
  super.initState();

  Future.microtask(() {
    if (!mounted) return;

    context.read<MissaoProvider>().carregarMissoes();
  });
}

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  int _calcularPontos(String dificuldade) {
    switch (dificuldade) {
      case 'Médio':
        return 20;
      case 'Difícil':
        return 30;
      default:
        return 10;
    }
  }

  Future<void> _cadastrarMissao() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o título da missão.'),
        ),
      );
      return;
    }

    final pontos = _calcularPontos(_dificuldadeSelecionada);

    final missao = Missao(
      titulo: titulo,
      dificuldade: _dificuldadeSelecionada,
      pontos: pontos,
    );

    await context.read<MissaoProvider>().adicionarMissao(missao);

    _tituloController.clear();

    setState(() {
      _dificuldadeSelecionada = 'Fácil';
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Missão cadastrada com sucesso!'),
      ),
    );
  }

  String _estrelas(String dificuldade) {
    switch (dificuldade) {
      case 'Médio':
        return '⭐⭐';
      case 'Difícil':
        return '⭐⭐⭐';
      default:
        return '⭐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissaoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Missões'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nova Missão',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tituloController,
                      decoration: const InputDecoration(
                        labelText: 'Título da missão',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _dificuldadeSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Dificuldade',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Fácil',
                          child: Text('⭐ Fácil - 10 pontos'),
                        ),
                        DropdownMenuItem(
                          value: 'Médio',
                          child: Text('⭐⭐ Médio - 20 pontos'),
                        ),
                        DropdownMenuItem(
                          value: 'Difícil',
                          child: Text('⭐⭐⭐ Difícil - 30 pontos'),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          setState(() {
                            _dificuldadeSelecionada = valor;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.carregando
                          ? null
                          : _cadastrarMissao,
                      child: const Text('CADASTRAR MISSÃO'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'PONTOS CONQUISTADOS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${provider.pontosConquistados}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Minhas Missões',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (provider.carregando)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (provider.missoes.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Nenhuma missão cadastrada.',
                    ),
                  ),
                ),
              )
            else
              ...provider.missoes.map(
                (missao) => _buildMissaoCard(
                  context,
                  missao,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissaoCard(
    BuildContext context,
    Missao missao,
  ) {
    final provider = context.read<MissaoProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              missao.titulo,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                decoration: missao.concluida
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dificuldade: ${_estrelas(missao.dificuldade)} ${missao.dificuldade}',
            ),
            const SizedBox(height: 4),
            Text(
              'Pontos: ${missao.pontos}',
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${missao.concluida ? 'Concluída' : 'Pendente'}',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!missao.concluida)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await provider.concluirMissao(missao);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Missão concluída! Você conquistou ${missao.pontos} pontos.',
                            ),
                          ),
                        );
                      },
                      child: const Text('CONCLUIR'),
                    ),
                  ),
                if (!missao.concluida)
                  const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (missao.id == null) return;

                      await provider.excluirMissao(missao.id!);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Missão removida.'),
                        ),
                      );
                    },
                    child: const Text('EXCLUIR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}