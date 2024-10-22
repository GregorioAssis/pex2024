import 'item_orcamento.dart';

class Orcamento {
  static int _contadorId = 1;
  int id;
  String placaVeiculo;
  String descricaoProblema;
  List<ItemOrcamento> itens;
  double maoDeObra;
  String status;
  Map<String, bool> itensAprovados;

  Orcamento({
    required this.placaVeiculo,
    required this.descricaoProblema,
    required this.itens,
    required this.maoDeObra,
    this.status = 'Aguardando aprovação',
  })  : id = _contadorId++,
        itensAprovados = {};
}
