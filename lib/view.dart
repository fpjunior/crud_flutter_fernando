import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  bool isEditar = true;
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
      backgroundColor: Color(0xff292C31),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
        title: Text("Editar Produto"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.db.delete(widget.produtos["id"]);
                Navigator.pop(context, true);
              }),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditar = !isEditar;
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  height:
                      mounted ? MediaQuery.of(context).size.height * 0.4 : 0,
                  child: Carousel(
                    autoplay: false,
                    animationCurve: Curves.fastOutSlowIn,
                    images: [
                      Image.network(widget.produtos['urlImage'] ?? "",
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                        return Image.asset(
                          'assets/logo.jpeg',
                          fit: BoxFit.cover,
                        );
                      })
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                isEditar == false
                    ? TextField(
                        readOnly: isEditar,
                        style: TextStyle(color: Colors.white),
                        controller: nameController,
                        decoration: InputDecoration(
                            labelText: "Nome",
                            labelStyle: TextStyle(
                              color: Color(0xffA9DED8),
                            )),
                      )
                    : Text(
                        widget.produtos["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                isEditar == false
                    ? TextField(
                        readOnly: isEditar,
                        style: TextStyle(color: Colors.white),
                        controller: descriptionController,
                        decoration: InputDecoration(
                            labelText: "Descrição",
                            labelStyle: TextStyle(
                              color: Color(0xffA9DED8),
                            )),
                      )
                    : Text(
                        descriptionController.text,
                        style: TextStyle(color: Colors.white),
                      ),
                SizedBox(
                  height: 20,
                ),
                isEditar == false
                    ? TextField(
                        readOnly: isEditar,
                        style: TextStyle(color: Colors.white),
                        controller: urlImageController,
                        decoration: InputDecoration(
                            labelText: "Url da Imagem",
                            labelStyle: TextStyle(
                              color: Color(0xffA9DED8),
                            )),
                      )
                    : Container(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            text: "Link: ",
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'Imagem1   ',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(widget.produtos["urlImage"]);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                isEditar == false
                    ? TextField(
                        style: TextStyle(color: Colors.white),
                        readOnly: isEditar,
                        controller: precoController,
                        decoration: InputDecoration(
                            labelText: "Média de Preço",
                            labelStyle: TextStyle(
                              color: Color(0xffA9DED8),
                            )),
                      )
                    : Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Média de Preço: ${precoController.text}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
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
