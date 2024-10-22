import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import 'criar_orcamento_screen.dart';
import '../models/orcamento.dart';
import '../widgets/orcamento_item.dart';
import 'confirmacao_screen.dart';
import 'cliente_orcamento_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Orcamento> _orcamentos = [];

  void _adicionarOrcamento(Orcamento orcamento) {
    setState(() {
      int index = _orcamentos.indexWhere((o) => o.id == orcamento.id);
      if (index != -1) {
        _orcamentos[index] = orcamento;
      } else {
        _orcamentos.add(orcamento);
      }
    });
  }

  void _abrirCriarOrcamento() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarOrcamentoScreen(
          onSalvarOrcamento: _adicionarOrcamento,
        ),
      ),
    );
  }

  void _abrirConfirmacao(Orcamento orcamento) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmacaoScreen(orcamento: orcamento),
      ),
    );
    setState(() {}); // Atualiza a tela após retornar
  }

  void _editarOrcamento(Orcamento orcamento) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarOrcamentoScreen(
          onSalvarOrcamento: _adicionarOrcamento,
          orcamentoExistente: orcamento,
        ),
      ),
    );
  }

  void _excluirOrcamento(Orcamento orcamento) {
    setState(() {
      _orcamentos.removeWhere((o) => o.id == orcamento.id);
    });
  }

  void _finalizarOrcamento(Orcamento orcamento) {
    setState(() {
      orcamento.status = 'Serviço Concluído';
    });
  }

  void _gerarLinkOrcamento(Orcamento orcamento) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteOrcamentoScreen(
          orcamento: orcamento,
        ),
      ),
    );

    if (resultado != null && resultado is Orcamento) {
      _adicionarOrcamento(resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel do Mecânico'),
      ),
      drawer: DrawerMenu(),
      body: _orcamentos.isEmpty
          ? Center(child: Text('Nenhum orçamento em andamento.'))
          : ListView.builder(
        itemCount: _orcamentos.length,
        itemBuilder: (context, index) {
          return OrcamentoItem(
            orcamento: _orcamentos[index],
            onTap: () => _abrirConfirmacao(_orcamentos[index]),
            onEditar: () => _editarOrcamento(_orcamentos[index]),
            onExcluir: () => _excluirOrcamento(_orcamentos[index]),
            onFinalizar: () => _finalizarOrcamento(_orcamentos[index]),
            onGerarLink: () => _gerarLinkOrcamento(_orcamentos[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCriarOrcamento,
        child: Icon(Icons.add),
        tooltip: 'Novo Orçamento',
      ),
    );
  }
}
