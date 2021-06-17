import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;
  int _offset = 0;

  Future<Map<String, dynamic>> _getGifs() async {
    http.Response response;

    if (_search == null || _search!.isEmpty) {
      var trendingUrl =
          "https://api.giphy.com/v1/gifs/trending?api_key=Bfkc2u2bg10PxFK3r3a6BlEZ6USjbn3J&limit=20&rating=g";

      response = await http.get(Uri.parse(trendingUrl));
    } else {
      var searchUrl =
          "https://api.giphy.com/v1/gifs/search?api_key=Bfkc2u2bg10PxFK3r3a6BlEZ6USjbn3J&q=$_search&limit=19&offset=$_offset &rating=g&lang=pt";

      response = await http.get(Uri.parse(searchUrl));
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) => {print(map)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return _createGifTable(context,
                            snapshot as AsyncSnapshot<Map<String, dynamic>>);
                      }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null || _search!.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(
      BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _getCount(snapshot.data!["data"]),
      itemBuilder: (context, index) {
        if (_search == null ||
            _search!.isEmpty ||
            index < snapshot.data!["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data!["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data!["data"][index]),
                ),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data!["data"][index]["images"]
                  ["fixed_height"]["url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 70),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                }),
          );
        }
      },
    );
  }
}
