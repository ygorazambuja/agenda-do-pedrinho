import 'dart:io';

import 'package:agenda_do_pedrinho/contato/adicionar_contato.dart';
import 'package:agenda_do_pedrinho/contato/contato_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



enum OpcoesDeOrdem { ordemAZ, ordemZA }

class AgendaHomePage extends StatefulWidget {
  @override
  _AgendaHomePageState createState() => _AgendaHomePageState();
}

class _AgendaHomePageState extends State<AgendaHomePage> {
  ContactHelper helper = ContactHelper();

  List<Contato> contatos = List();

  @override
  void initState() {
    super.initState();

    _getContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agenda do Pedrinho"),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<OpcoesDeOrdem>(
              itemBuilder: (context) => <PopupMenuEntry<OpcoesDeOrdem>>[
                const PopupMenuItem(
                  child: Text("Ordenar de A-Z"),
                  value: OpcoesDeOrdem.ordemAZ,
                ),
                const PopupMenuItem(
                  child: Text("Ordenar de Z-A"),
                  value: OpcoesDeOrdem.ordemZA,
                )
              ],
              onSelected: _ordenaLista,
            )
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _mostraPaginaDeContato();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.indigo,
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: contatos.length,
            itemBuilder: (context, index) {
              return _contatoCard(context, index);
            }));
  }

  Widget _contatoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contatos[index].img != null
                          ? FileImage(File(contatos[index].img))
                          : AssetImage("images/person.jpg"),
                      fit: BoxFit.cover)),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contatos[index].nome ?? "",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    contatos[index].email ?? "",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    contatos[index].telefone ?? "",
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {
                            launch("tel:${contatos[index].telefone}");
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Ligar",
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 20.0),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _mostraPaginaDeContato(contact: contatos[index]);
                          },
                          child: Text(
                            "Editar",
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 20.0),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {
                            helper.deleteContact(contatos[index].id);
                            setState(() {
                              contatos.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            "Excluir",
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 20.0),
                          )),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _mostraPaginaDeContato({Contato contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getContatos();
    }
  }

  void _getContatos() {
    helper.getAllContacts().then((list) {
      setState(() {
        contatos = list;
      });
    });
  }

  void _ordenaLista(OpcoesDeOrdem result) {
    switch (result) {
      case OpcoesDeOrdem.ordemAZ:
        contatos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OpcoesDeOrdem.ordemZA:
        contatos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
