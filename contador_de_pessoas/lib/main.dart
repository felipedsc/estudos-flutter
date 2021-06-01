import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pessoas = 1;
  String mensagemEntrada = "Pode entrar!";

  void _changePeople(int delta) {
    setState(() {
      pessoas += delta;

      if (pessoas < 0) {
        mensagemEntrada = "Mundo invertido";
      } else if (pessoas <= 9) {
        mensagemEntrada = "Pode entrar!";
      } else {
        mensagemEntrada = "Lotado!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pessoas: $pessoas",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextButton(
                  child: Text("+1",
                      style: TextStyle(fontSize: 40, color: Colors.white)),
                  onPressed: () => {_changePeople(1)},
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextButton(
                    child: Text("-1",
                        style: TextStyle(fontSize: 40, color: Colors.white)),
                    onPressed: () => {_changePeople(-1)},
                  )),
            ]),
            Text(
              mensagemEntrada,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
            ),
          ],
        ),
      ],
    );
  }
}
