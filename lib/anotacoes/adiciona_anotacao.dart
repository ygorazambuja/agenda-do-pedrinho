import 'dart:core';

import 'package:agenda_do_pedrinho/anotacoes/anotacao_model.dart';
import 'package:flutter/material.dart';

class AdicionaAnotacao extends StatefulWidget {
  final Anotacao anotacao;

  AdicionaAnotacao({this.anotacao});

  @override
  _AdicionaAnotacaoState createState() => _AdicionaAnotacaoState();
}

class _AdicionaAnotacaoState extends State<AdicionaAnotacao> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _informacoesController = TextEditingController();

  bool _userEdited = false;
  Anotacao _anotacaoEdited;

  @override
  void initState() {
    super.initState();

    if (widget.anotacao == null) {
      _anotacaoEdited = Anotacao();
    } else {
      _anotacaoEdited = Anotacao.fromMap(widget.anotacao.toMap());
      _tituloController.text = _anotacaoEdited.titulo;
      _informacoesController.text = _anotacaoEdited.informacoes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adicionar Anotacao'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, _anotacaoEdited);
            },
            label: Text('Salvar')),
        body: Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Titulo',
                ),
                controller: _tituloController,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _anotacaoEdited.titulo = text;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Informações',
                ),
                controller: _informacoesController,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _anotacaoEdited.informacoes = text;
                  });
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton.icon(
                      highlightElevation: 5,
                      shape: StadiumBorder(),
                      icon:
                          Icon(Icons.calendar_today, color: Colors.blueAccent),
                      label: Text('Calendario'),
                      onPressed: () async {
                        _userEdited = true;
                        final dtPick = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (dtPick != null &&
                            dtPick != _anotacaoEdited.dateTime) {
                          setState(() {
                            _anotacaoEdited.dateTime = dtPick.toIso8601String();
                          });
                        }
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alteraçōes?"),
              content: Text("Se sair as alteraçōes serão perdidas."),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Sim"))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
