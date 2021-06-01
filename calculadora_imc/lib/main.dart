import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String textoInformativo = "Informe seus dados!";

  void limparCampos() {
    pesoController.text = "";
    alturaController.text = "";
    formKey = GlobalKey<FormState>();

    setState(() {
      textoInformativo = "Informe seus dados!";
    });
  }

  void calcular() {
    bool valido = formKey.currentState?.validate() ?? false;

    if (valido) {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text) / 100;

      double imc = peso / (altura * altura);
      print(imc);
      String valorImc = imc.toStringAsPrecision(4);
      String novoTextoInformativo = "IMC $valorImc";

      if (imc < 18.6) {
        novoTextoInformativo += " (abaixo do peso)";
      } else {
        novoTextoInformativo += " Não vou fazer esse monte de condição";
      }

      setState(() {
        textoInformativo = novoTextoInformativo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: [
            IconButton(onPressed: limparCampos, icon: Icon(Icons.refresh))
          ]),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person_outline,
                size: 110,
                color: Colors.green,
              ),
              TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: Colors.green)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25),
                  controller: pesoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Insira seu peso.";
                    }
                  }),
              TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(color: Colors.green)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25),
                  controller: alturaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Insira sua altura";
                    }
                  }),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: calcular,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      textStyle: TextStyle(fontSize: 20),
                    ),
                    child: Text("Calcular"),
                  ),
                ),
              ),
              Text(
                textoInformativo,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
              )
            ],
          ),
        ),
      ),
    );
  }
}
