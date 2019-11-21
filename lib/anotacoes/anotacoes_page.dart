import 'package:agenda_do_pedrinho/anotacoes/adiciona_anotacao.dart';
import 'package:agenda_do_pedrinho/anotacoes/anotacao_model.dart';
import 'package:flutter/material.dart';

class AnotacoesHomePage extends StatefulWidget {
  @override
  _AnotacoesHomePageState createState() => _AnotacoesHomePageState();
}

class _AnotacoesHomePageState extends State<AnotacoesHomePage> {
  int count = 0;
  AnotacaoHelper helper = AnotacaoHelper();
  List<Anotacao> anotacoes = List();

  @override
  void initState() {
    super.initState();
    _getAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anotações'),
      ),
      body: getAnotacoesListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdicionaAnotacao()));
        },
        label: Text('Nova Tarefa'),
        icon: Icon(Icons.add),
      ),
    );
  }

  ListView getAnotacoesListView() {
    return ListView.builder(
      itemCount: anotacoes.length,
      itemBuilder: (BuildContext context, index) {
        return anotacaoToCard(index);
      },
    );
  }

  Card anotacaoToCard(int index) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.yellow,
          child: Icon(Icons.keyboard_arrow_right),
        ),
        title: Text(anotacoes[index].titulo),
        subtitle: Text(anotacoes[index].informacoes),
        trailing: Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onTap: () {
          debugPrint('Teste pritn');
        },
      ),
    );
  }

  void _getAnotacoes() {
    helper.getTodasAnotacoes().then((list) {
      setState(() {
        anotacoes = list;
      });
    });
  }
}
