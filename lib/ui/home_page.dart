import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _buscar;

  int _offset = 0;

  _buscarGifs() async {
    http.Response response; //Declara a variavel que vai traser as respostas do link

    if (_buscar == null || _buscar.isEmpty) //Nulo ou vazio são diferentes.
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=3cK9CE4lcVQ9UTkVh0RBPkPOrq9UMz0a&limit=20&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=3cK9CE4lcVQ9UTkVh0RBPkPOrq9UMz0a&q=$_buscar&limit=19&offset=$_offset&rating=G&lang=pt");

    return jsonDecode(response.body); //Trata o json trasido pelo response como um corpo
  }

  @override
  void initState() {
    super.initState();
    _buscarGifs().then((Map) { //O buscar gifs agora terá 1 mapa
      print(Map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (Text) {
                setState(() {
                  _buscar = Text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _buscarGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _criarTabela(context, snapshot);
                  }
                }),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_buscar == null || _buscar.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _criarTabela(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder( 
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_buscar == null || index < snapshot.data["data"].length)
          return GestureDetector( //detecta a ação que fizer
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
            },
            child: FadeInImage.memoryNetwork( //Trazer a imagem com uma animação
              placeholder: kTransparentImage, //pacote de imagem transparent placeholder é a imagem anterior
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0),
                  Text(
                    "Carregar Mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
      },
    );
  }
}
