import 'dart:io';

import 'package:agenda_do_pedrinho/contato/contato_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contato contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _enderecoController = TextEditingController();

  bool masculino = false;
  bool feminino = false;

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contato _contatoEditado;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _contatoEditado = Contato();
    } else {
      _contatoEditado = Contato.fromMap(widget.contact.toMap());


      _nameController.text = _contatoEditado.nome;
      _emailController.text = _contatoEditado.email;
      _telefoneController.text = _contatoEditado.telefone;
      _cpfController.text = _contatoEditado.cpf;
      _enderecoController.text = _contatoEditado.endereco;
      _instagramController.text = _contatoEditado.instagram;
      _facebookController.text = _contatoEditado.facebook;

      if (_contatoEditado.sexo == 'masculino') masculino = true;
      if (_contatoEditado.sexo == 'feminino') feminino = true;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text(_contatoEditado.nome ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (_contatoEditado.nome != null &&
                  _contatoEditado.nome.isNotEmpty) {
                Navigator.pop(context, _contatoEditado);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            label: Text('Salvar'),
            icon: Icon(Icons.save),
            backgroundColor: Colors.indigo,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _contatoEditado.img != null
                                ? FileImage(File(_contatoEditado.img))
                                : AssetImage("images/person.jpg"),
                            fit: BoxFit.cover)),
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.camera)
                        .then((file) {
                      if (file == null) return;
                      setState(() {
                        _contatoEditado.img = file.path;
                      });
                    });
                  },
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: TextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            labelText: "Nome",
                            icon: Icon(Icons.person),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _contatoEditado.nome = text;
                          });
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            labelText: "Email",
                            icon: Icon(Icons.email),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _contatoEditado.email = text;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: TextField(
                        controller: _telefoneController,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            labelText: "Telefone: ",
                            icon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _contatoEditado.telefone = text;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: TextField(
                        controller: _cpfController,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            labelText: "CPF: ",
                            icon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _contatoEditado.cpf = text;
                          });
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text("Masculino"),
                            Checkbox(
                              value: masculino,
                              onChanged: (value) {
                                setState(() {
                                  masculino = value;
                                  _contatoEditado.sexo =
                                  masculino ? 'masculino' : 'feminino';
                                });
                              },
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text("Feminino"),
                            Checkbox(
                              value: feminino,
                              onChanged: (value) {
                                setState(() {
                                  feminino = value;
                                  _contatoEditado.sexo =
                                  feminino ? 'feminino' : 'masculino';
                                });
                              },
                            )
                          ],
                        ),
                        RaisedButton(
                          onPressed: () async {
                            final datePicker = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (datePicker != null &&
                                datePicker != _contatoEditado.dataNascimento) {
                              setState(() {
                                _contatoEditado.dataNascimento =
                                    datePicker.toIso8601String();
                              });
                            }
                          },
                          child: Text(_contatoEditado.dataNascimento == null
                              ? 'Data de Nascimento'
                              : 'dia : ${DateTime
                              .parse(_contatoEditado.dataNascimento)
                              .day}, mes: ${DateTime
                              .parse(_contatoEditado.dataNascimento)
                              .month}, ano: ${DateTime
                              .parse(_contatoEditado.dataNascimento)
                              .year} '),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: TextField(
                        controller: _instagramController,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            labelText: "Instagram: ",
                            icon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _contatoEditado.instagram = text;
                          });
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: TextField(
                        controller: _facebookController,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                            labelText: "Facebook: ",
                            icon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _contatoEditado.facebook = text;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
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
