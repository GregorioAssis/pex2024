import 'package:flutter/material.dart';
import '../models/orcamento.dart';

class OrcamentoItem extends StatelessWidget {
  final Orcamento orcamento;
  final VoidCallback onTap;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;
  final VoidCallback onFinalizar;
  final VoidCallback onGerarLink;

  OrcamentoItem({
    required this.orcamento,
    required this.onTap,
    required this.onEditar,
    required this.onExcluir,
    required this.onFinalizar,
    required this.onGerarLink,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Orçamento ${orcamento.id} - ${orcamento.status}'),
      subtitle: Text('Placa: ${orcamento.placaVeiculo}'),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'Editar') {
            onEditar();
          } else if (value == 'Excluir') {
            onExcluir();
          } else if (value == 'Finalizar') {
            onFinalizar();
          } else if (value == 'Gerar Link') {
            onGerarLink();
          }
        },
        itemBuilder: (BuildContext context) {
          return {'Editar', 'Excluir', 'Finalizar', 'Gerar Link'}.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
      onTap: onTap,
    );
  }
}
