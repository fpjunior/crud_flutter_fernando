import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database.dart';

class View extends StatefulWidget {
  View({Key key, this.produtos, this.db}) : super(key: key);
  Map produtos;
  Database db;
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController urlImageController = new TextEditingController();
  TextEditingController precoController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    print(widget.produtos);
    nameController.text = widget.produtos['name'];
    descriptionController.text = widget.produtos['description'];
    urlImageController.text = widget.produtos['urlImage'];
    precoController.text = widget.produtos['preco'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
        title: Text("Editar Produto"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.db.delete(widget.produtos["id"]);
                Navigator.pop(context, true);
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(
              widget.produtos["urlImage"],
              width: 300,
              fit: BoxFit.cover,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: urlImageController,
              decoration: InputDecoration(
                  labelText: "Url da imagem",
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: precoController,
              decoration: InputDecoration(
                  labelText: "Preço",
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.db.update(
              widget.produtos['id'],
              nameController.text,
              descriptionController.text,
              urlImageController.text,
              precoController.text);
          Navigator.pop(context, true);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      focusColor: Colors.white,
      labelStyle: TextStyle(color: Colors.white),
      labelText: labelText,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }
}
