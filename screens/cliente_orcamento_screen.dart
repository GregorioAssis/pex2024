import 'package:flutter/material.dart';
import '../models/orcamento.dart';
import 'confirmacao_screen.dart';

class ClienteOrcamentoScreen extends StatefulWidget {
  final Orcamento orcamento;

  ClienteOrcamentoScreen({required this.orcamento});

  @override
  _ClienteOrcamentoScreenState createState() => _ClienteOrcamentoScreenState();
}

class _ClienteOrcamentoScreenState extends State<ClienteOrcamentoScreen> {
  Map<String, bool> _itensSelecionados = {};

  @override
  void initState() {
    super.initState();
    widget.orcamento.itens.forEach((item) {
      _itensSelecionados[item.nomePeca] = true;
    });
  }

  double _calcularTotal() {
    double total = 0.0;
    widget.orcamento.itens.forEach((item) {
      if (_itensSelecionados[item.nomePeca] == true) {
        total += item.valorUnitario * item.quantidade;
      }
    });
    total += widget.orcamento.maoDeObra;
    return total;
  }

  void _confirmarSelecao() {
    widget.orcamento.itensAprovados = _itensSelecionados;
    widget.orcamento.status = 'Aprovado pelo cliente';

    // Navega para a tela de confirmação sem possibilidade de retorno (Vizualização do cliente)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmacaoScreen(orcamento: widget.orcamento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloqueia o botão de retorno (Vizualização do cliente)
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orçamento ${widget.orcamento.id}'),
          automaticallyImplyLeading: false, // Remove o botão de retorno (Vizualização do cliente)
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Descrição: ${widget.orcamento.descricaoProblema}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Itens do Orçamento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView(
                  children: widget.orcamento.itens.map((item) {
                    return CheckboxListTile(
                      title: Text(
                          '${item.nomePeca} (x${item.quantidade}) - R\$ ${(item.valorUnitario * item.quantidade).toStringAsFixed(2)}'),
                      value: _itensSelecionados[item.nomePeca],
                      onChanged: (value) {
                        setState(() {
                          _itensSelecionados[item.nomePeca] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Text(
                'Mão de Obra: R\$ ${widget.orcamento.maoDeObra.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Total: R\$ ${_calcularTotal().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Aprovar Orçamento'),
                onPressed: _confirmarSelecao,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
