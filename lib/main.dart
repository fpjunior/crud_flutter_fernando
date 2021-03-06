import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/database.dart';
import 'package:firebase_crud/widgets/splashScreen.dart';
import 'package:firebase_crud/view.dart';
import 'package:firebase_crud/pages/cadastrar_produtos.dart';
import 'package:flutter/material.dart';

import 'core/colors.dart';

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
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.filter}) : super(key: key);

  final String filter;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchResult = '';

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Produtos');

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

  Future<void> _reloadList() async {
    var newDocs =
        await Future.delayed(Duration(seconds: 1), () => initialise());
    setState(() {
      docs = newDocs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.kBackgroundColor,
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchResult = '';

                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  // Perform set of instructions.
                  customSearchBar = ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          searchResult = text;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'digite o nome do produto',
                        hintStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Lista de Produtos');
                  });
                }
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder(
          future: db.read(),
          builder: (context, index) {
            if (index.connectionState == ConnectionState.done) {
              if (index.data == null) {
                return Center(child: Text("Erro ao carregar dados"));
              } else {
                if (docs.isEmpty == 0) {
                  return Center(child: Text("Nenhum produto encontrado"));
                }

                List list = [];

                if (docs.isNotEmpty) {
                  for (dynamic item in docs) {
                    String name = item['name'].toString().toLowerCase();
                    if (name.contains(searchResult.toLowerCase())) {
                      list.add(item);
                    }
                  }
                } else {
                  list.addAll(docs);
                }
                return RefreshIndicator(
                  onRefresh: _reloadList,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        padding: new EdgeInsets.only(right: 2.0),
                        child: Card(
                          // semanticContainer: true,
                          // clipBehavior: Clip.antiAliasWithSaveLayer,
                          // elevation: 5,
                          color: AppColors.kColorCard,
                          // margin: EdgeInsets.all(4),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditarProduto(
                                          produtos: list[index],
                                          db: db))).then((value) => {
                                    if (value != null) {initialise()}
                                  });
                            },
                            // contentPadding:
                            //     EdgeInsets.only(right: 30, left: 36),
                            title: Container(
                              child: Text(
                                list[index]['name'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                child:
                                    Image.network(list[index]['urlImage'] ?? "",
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace stackTrace) {
                                  return Image.asset('assets/logo.png',
                                      fit: BoxFit.cover);
                                })),
                            subtitle: Text(
                              list[index]['description'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.kColorSubtitle,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }

            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 10),
        child: SizedBox(
          width: 40,
          child: FloatingActionButton(
            backgroundColor: AppColors.kColotBtnAdd,
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastrarProdutos(db: db)))
                  .then((value) {
                if (value != null) {
                  initialise();
                }
              });
            },
            tooltip: 'Cadastrar um novo produto',
            child: Icon(
              Icons.add,
            ),
          ),
        ),
      ), // This t
    );
  }
}
