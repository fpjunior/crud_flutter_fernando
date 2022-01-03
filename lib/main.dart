import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/database.dart';
import 'package:firebase_crud/widgets/splashScreen.dart';
import 'package:firebase_crud/view.dart';
import 'package:firebase_crud/pages/cadastrar_produtos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Future<FirebaseApp> app = Firebase.initializeApp();

//   if (app == null) {
//     app = Firebase.initializeApp();
//     await Firebase.initializeApp(
//       // Replace with actual values
//       options: FirebaseOptions(
//         apiKey: "XXX",
//         appId: "1:634861432791:android:f4a163ea4b78e16ebf2592",
//         messagingSenderId: "XXX",
//         projectId: "crud-27136",
//       ),
//     );
//   } else {
//     app; // if already initialized, use that one
//   }
//   runApp(MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SecondScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database db;
  List docs = [];
  initialise() {
    db = Database();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
          title: Center(child: Text("Lista de Produtos")),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CadastrarProdutos(db: db))).then((value) {
                      if (value != null) {
                        initialise();
                      }
                    });
                  },
                  tooltip: 'Cadastrar um novo produto',
                  child: Icon(Icons.add),
                ),
              ),
            ), // This t
          ],
        ),
        body: FutureBuilder(
            future: db.read(),
            builder: (context, index) {
              if (index.connectionState == ConnectionState.done) {
                if (index.data == null) {
                  return Center(child: Text("Erro ao carregar dados"));
                } else {
                  return ListView.builder(
                    itemCount: docs?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        padding: new EdgeInsets.only(right: 13.0),
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          color: Color(0xff292C31),
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditarProduto(
                                          produtos: docs[index],
                                          db: db))).then((value) => {
                                    if (value != null) {initialise()}
                                  });
                            },
                            contentPadding:
                                EdgeInsets.only(right: 30, left: 36),
                            title: Text(
                              docs[index]['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            leading: Container(
                                width: 70,
                                height: 70,
                                child:
                                    Image.network(docs[index]['urlImage'] ?? "",
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace stackTrace) {
                                  return Image.asset(
                                    'assets/logo.jpeg',
                                    fit: BoxFit.cover,
                                  );
                                })),
                            subtitle: Text(
                              docs[index]['description'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xffA9DED8),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return Center(child: CircularProgressIndicator());
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => CadastrarProdutos(db: db))).then((value) {
              //       if (value != null) {
              //         initialise();
              //       }
              //     });
              //   },
              //   tooltip: 'Cadastrar um novo produto',
              //   child: Icon(Icons.add),
              // ), // This trailing comma makes auto-formatting nicer for build methods.
            }));
  }
}

class SlideAnimation3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Go Back"),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.all(_w / 30),
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              delay: Duration(milliseconds: 100),
              child: SlideAnimation(
                duration: Duration(milliseconds: 2500),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(milliseconds: 2500),
                  child: Container(
                    margin: EdgeInsets.only(bottom: _w / 20),
                    height: _w / 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
