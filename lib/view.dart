import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/colors.dart';
import 'database.dart';

class EditarProduto extends StatefulWidget {
  EditarProduto({Key key, this.produtos, this.db}) : super(key: key);
  Map produtos;
  Database db;
  @override
  _EditarProdutoState createState() => _EditarProdutoState();
}

class _EditarProdutoState extends State<EditarProduto> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController urlImageController = new TextEditingController();
  TextEditingController urlImage2Controller = new TextEditingController();
  TextEditingController precoController = new TextEditingController();

  bool isEditar = true;
  @override
  void initState() {
    super.initState();
    print(widget.produtos);
    nameController.text = widget.produtos['name'];
    descriptionController.text = widget.produtos['description'];
    urlImageController.text = widget.produtos['urlImage'];
    urlImage2Controller.text = widget.produtos['urlImage2'];
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Tem certeza que deseja excluir esse produto?",
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Sim",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () => {
                              widget.db.delete(widget.produtos["id"]),
                              Navigator.pop(context, true),
                              Navigator.pop(context, true),
                              Fluttertoast.showToast(
                                msg: 'Produto excluído com sucesso!',
                              ),
                            },
                          ),
                          FlatButton(
                            child: Text("Não",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                        // content: Text("Body"),
                      );
                    });
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
                  child: widget.produtos['urlImage2'] != null &&
                          widget.produtos['urlImage2'] != ""
                      ? Carousel(
                          autoplay: false,
                          boxFit: BoxFit.cover,
                          images: [
                            Image.network(widget.produtos['urlImage'] ?? "",
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                              return Image.asset(
                                'assets/logo.png',
                                cacheHeight: 300,
                              );
                            }),
                            Image.network(widget.produtos['urlImage2'],
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                              return Container(
                                child: Image.asset(
                                  'assets/logo.png',
                                  cacheHeight: 300,
                                ),
                              );
                            })
                          ],
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotColor: Colors.white,
                          indicatorBgPadding: 5.0,
                          dotBgColor: Colors.grey,
                        )
                      : Carousel(
                          autoplay: false,
                          boxFit: BoxFit.cover,
                          images: [
                            Image.network(widget.produtos['urlImage'] ?? "",
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                              return Container(
                                child: Image.asset(
                                  'assets/logo.png',
                                  cacheHeight: 300,
                                ),
                              );
                            }),
                          ],
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotColor: Colors.white,
                          indicatorBgPadding: 5.0,
                          dotBgColor: Colors.transparent,
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
                            border: OutlineInputBorder(),
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
                    ? TextFormField(
                        maxLines:
                            descriptionController.text.length < 44 ? null : 5,
                        textCapitalization: TextCapitalization.sentences,
                        readOnly: isEditar,
                        style: TextStyle(color: Colors.white),
                        controller: descriptionController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
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
                    ? TextFormField(
                        readOnly: isEditar,
                        style: TextStyle(color: Colors.white),
                        controller: urlImageController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Url da Imagem",
                          labelStyle: TextStyle(
                            color: Color(0xffA9DED8),
                          ),
                        ))
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
                    ? TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        readOnly: isEditar,
                        controller: precoController,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: AppColors.kLabelTextField,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Média de Preço",
                            prefixText: "R\$",
                            prefixStyle: TextStyle(color: Colors.white),
                            suffixText: "Reais",
                            suffixStyle:
                                TextStyle(color: AppColors.kSuffixTextField)),
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
      floatingActionButton: !isEditar
          ? FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Tem certeza que deseja salvar as alterações?",
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Sim",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () => {
                              widget.db.update(
                                  widget.produtos['id'],
                                  nameController.text,
                                  descriptionController.text,
                                  urlImageController.text,
                                  urlImage2Controller.text,
                                  precoController.text),
                              Navigator.pop(context, true),
                              isEditar = true,
                              Fluttertoast.showToast(
                                msg: 'Alteração realizada com sucesso!',
                              ),
                            },
                          ),
                          TextButton(
                            child: Text("Não",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                        // content: Text("Body"),
                      );
                    });
              },
              child: Icon(Icons.save),
              backgroundColor: Colors.green,
            )
          : Container(),
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
