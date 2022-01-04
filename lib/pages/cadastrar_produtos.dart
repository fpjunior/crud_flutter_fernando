import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../database.dart';

class CadastrarProdutos extends StatefulWidget {
  CadastrarProdutos({Key key, this.db}) : super(key: key);
  Database db;

  @override
  CadastrarProdutosState createState() => CadastrarProdutosState();
}

class CadastrarProdutosState extends State<CadastrarProdutos>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController urlImageController = new TextEditingController();
  TextEditingController precoController = new TextEditingController();

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: .7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )
      ..addListener(
        () {
          setState(() {});
        },
      )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        },
      );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
        title: Text("Cadastrar Produto"),
      ),
      backgroundColor: Color(0xff292C31),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: _height,
            child: Column(
              children: [
                // Expanded(child: SizedBox()),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // SizedBox(),
                      // Text(
                      //   'CADASTRAR PRODUTO',
                      //   style: TextStyle(
                      //     fontSize: 25,
                      //     fontWeight: FontWeight.w600,
                      //     color: Color(0xffA9DED8),
                      //   ),
                      // ),
                      SizedBox(),
                      component1('Nome...', nameController),
                      component1('Descrição...', descriptionController),
                      component1('Url...', urlImageController),
                      component1('Média de Preço...', precoController),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: _width / 10),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: _width * .09),
                          height: _width * .8,
                          width: _width * .8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Color(0xff09090A),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Transform.scale(
                          scale: _animation.value,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              widget.db.create(
                                  nameController.text,
                                  descriptionController.text,
                                  urlImageController.text,
                                  precoController.text);
                              Navigator.pop(context, true);

                              HapticFeedback.lightImpact();
                              Fluttertoast.showToast(
                                msg: 'Produto Cadastrado com Sucesso!',
                              );
                            },
                            child: Container(
                              height: _width * .3,
                              // width: _width * .8,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xffA9DED8),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                'CADASTRAR',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget component1(String hintText, TextEditingController field) {
    double _width = MediaQuery.of(context).size.width;

    return Container(
      height: _width / 8,
      width: _width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: _width / 30),
      decoration: BoxDecoration(
        color: Color(0xff212428),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: field,
        style: TextStyle(color: Colors.white.withOpacity(.9)),
        decoration: InputDecoration(
          prefix: Text('     '),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(.5),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
