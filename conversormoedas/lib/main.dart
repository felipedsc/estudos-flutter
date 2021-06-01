import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  const url = "https://api.hgbrasil.com/finance?format=json&key=9670c0b5";
  http.Response response = await http.get(Uri.parse(url));

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController realController = TextEditingController();
  final TextEditingController dolarController = TextEditingController();
  final TextEditingController euroController = TextEditingController();

  double dolar = 0;
  double euro = 0;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor de moedas \$"),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: FutureBuilder(
            builder: (context, snapshot) {
              Map<dynamic, dynamic> dataResult =
                  snapshot.data! as Map<dynamic, dynamic>;

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Carregando dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao carregar dados!",
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dolar = double.parse(dataResult["results"]["currencies"]
                            ["USD"]["buy"]
                        .toString());
                    euro = double.parse(dataResult["results"]["currencies"]
                            ["EUR"]["buy"]
                        .toString());

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.monetization_on,
                              size: 150, color: Colors.amber),
                          buildTextField(
                              "Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$", dolarController,
                              _dolarChanged),
                          Divider(),
                          buildTextField(
                              "Euros", "€", euroController, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            },
            future: getData()));
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function(String) onChanged) {
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    controller: controller,
    onChanged: onChanged,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
