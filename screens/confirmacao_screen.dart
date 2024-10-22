import 'package:flutter/material.dart';
import '../models/orcamento.dart';

class ConfirmacaoScreen extends StatelessWidget {
  final Orcamento orcamento;

  ConfirmacaoScreen({required this.orcamento});

  @override
  Widget build(BuildContext context) {
    double totalAprovado = 0.0;
    orcamento.itens.forEach((item) {
      if (orcamento.itensAprovados[item.nomePeca] == true) {
        totalAprovado += item.valorUnitario * item.quantidade;
      }
    });
    totalAprovado += orcamento.maoDeObra;

    return WillPopScope(
      onWillPop: () async => false, // Bloqueia o retorno (Vizualização do cliente)
      child: Scaffold(
        appBar: AppBar(
          title: Text('Status do Orçamento'),
          automaticallyImplyLeading: false, // Remove o botão de retorno (Vizualização do cliente)
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Status: ${orcamento.status}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Itens Aprovados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView(
                  children: orcamento.itens.map((item) {
                    if (orcamento.itensAprovados[item.nomePeca] == true) {
                      return ListTile(
                        title: Text(
                          '${item.nomePeca} (x${item.quantidade}) - R\$ ${(item.valorUnitario * item.quantidade).toStringAsFixed(2)}',
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ),
              Text(
                'Total Aprovado: R\$ ${totalAprovado.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Entraremos em contato para prosseguir com o serviço.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
