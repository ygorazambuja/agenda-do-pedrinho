import 'dart:io';

import 'package:agenda_do_pedrinho/contato_model.dart';
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

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contato _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contato();
    } else {
      _editedContact = Contato.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.nome;
      _emailController.text = _editedContact.email;
      _telefoneController.text = _editedContact.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text(_editedContact.nome ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (_editedContact.nome != null &&
                  _editedContact.nome.isNotEmpty) {
                Navigator.pop(context, _editedContact);
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
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact.img))
                                : AssetImage("images/person.jpg"),
                            fit: BoxFit.cover)),
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.camera)
                        .then((file) {
                      if (file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      child: TextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        style: TextStyle(color: Colors.black87, fontSize: 24),
                        decoration: InputDecoration(
                            labelText: "Nome",
                            icon: Icon(Icons.person),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          setState(() {
                            _editedContact.nome = text;
                          });
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.black87, fontSize: 24),
                        decoration: InputDecoration(
                            labelText: "Email",
                            icon: Icon(Icons.email),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          _editedContact.email = text;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      child: TextField(
                        controller: _telefoneController,
                        style: TextStyle(color: Colors.black87, fontSize: 24),
                        decoration: InputDecoration(
                            labelText: "Telefone: ",
                            icon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          _userEdited = true;
                          _editedContact.telefone = text;
                        },
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                    )
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
