import 'package:flutter/material.dart';
import '../models/orcamento.dart';
import '../models/item_orcamento.dart';

class CriarOrcamentoScreen extends StatefulWidget {
  final Function(Orcamento) onSalvarOrcamento;
  final Orcamento? orcamentoExistente;

  CriarOrcamentoScreen({required this.onSalvarOrcamento, this.orcamentoExistente});

  @override
  _CriarOrcamentoScreenState createState() => _CriarOrcamentoScreenState();
}

class _CriarOrcamentoScreenState extends State<CriarOrcamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _placaVeiculo = '';
  String _descricaoProblema = '';
  List<ItemOrcamento> _itens = [];
  double _maoDeObra = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.orcamentoExistente != null) {
      _placaVeiculo = widget.orcamentoExistente!.placaVeiculo;
      _descricaoProblema = widget.orcamentoExistente!.descricaoProblema;
      _itens = List.from(widget.orcamentoExistente!.itens);
      _maoDeObra = widget.orcamentoExistente!.maoDeObra;
    }
  }

  void _adicionarItem() {
    TextEditingController nomeController = TextEditingController();
    TextEditingController quantidadeController = TextEditingController();
    TextEditingController valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Peça'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nome da Peça'),
                controller: nomeController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                controller: quantidadeController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Valor Unitário'),
                keyboardType: TextInputType.number,
                controller: valorController,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Adicionar'),
              onPressed: () {
                setState(() {
                  _itens.add(
                    ItemOrcamento(
                      nomePeca: nomeController.text,
                      quantidade: int.tryParse(quantidadeController.text) ?? 1,
                      valorUnitario: double.tryParse(valorController.text) ?? 0.0,
                    ),
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _editarItem(int index) {
    ItemOrcamento item = _itens[index];
    TextEditingController nomeController = TextEditingController(text: item.nomePeca);
    TextEditingController quantidadeController = TextEditingController(text: item.quantidade.toString());
    TextEditingController valorController = TextEditingController(text: item.valorUnitario.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Peça'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nome da Peça'),
                controller: nomeController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                controller: quantidadeController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Valor Unitário'),
                keyboardType: TextInputType.number,
                controller: valorController,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  _itens[index] = ItemOrcamento(
                    nomePeca: nomeController.text,
                    quantidade: int.tryParse(quantidadeController.text) ?? 1,
                    valorUnitario: double.tryParse(valorController.text) ?? 0.0,
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _excluirItem(int index) {
    setState(() {
      _itens.removeAt(index);
    });
  }

  void _salvarOrcamento() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Orcamento orcamentoAtualizado;
      if (widget.orcamentoExistente != null) {
        orcamentoAtualizado = widget.orcamentoExistente!;
        orcamentoAtualizado.placaVeiculo = _placaVeiculo;
        orcamentoAtualizado.descricaoProblema = _descricaoProblema;
        orcamentoAtualizado.itens = _itens;
        orcamentoAtualizado.maoDeObra = _maoDeObra;
      } else {
        orcamentoAtualizado = Orcamento(
          placaVeiculo: _placaVeiculo,
          descricaoProblema: _descricaoProblema,
          itens: _itens,
          maoDeObra: _maoDeObra,
        );
      }

      widget.onSalvarOrcamento(orcamentoAtualizado);

      Navigator.pop(context, orcamentoAtualizado);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Orçamento'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration:
                InputDecoration(labelText: 'Placa do Veículo'),
                initialValue: _placaVeiculo,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a placa do veículo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _placaVeiculo = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Descrição do Serviço'),
                initialValue: _descricaoProblema,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição do serviço';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descricaoProblema = value!;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Lista de Peças',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._itens.asMap().entries.map((entry) {
                int index = entry.key;
                ItemOrcamento item = entry.value;

                return ListTile(
                  title: Text('${item.nomePeca} (x${item.quantidade})'),
                  subtitle: Text(
                      'Valor Unitário: R\$ ${item.valorUnitario.toStringAsFixed(2)}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Editar') {
                        _editarItem(index);
                      } else if (value == 'Excluir') {
                        _excluirItem(index);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Editar', 'Excluir'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                );
              }).toList(),
              ElevatedButton(
                child: Text('Adicionar Peça'),
                onPressed: _adicionarItem,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mão de Obra'),
                initialValue: _maoDeObra != 0.0 ? _maoDeObra.toString() : '',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor da mão de obra';
                  }
                  return null;
                },
                onSaved: (value) {
                  _maoDeObra = double.tryParse(value!) ?? 0.0;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Criar Orçamento'),
                onPressed: _salvarOrcamento,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
