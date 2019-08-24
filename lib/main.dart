import 'package:flutter/material.dart';
import 'package:buscador_gifs/ui/home_page.dart';
import 'package:buscador_gifs/ui/gif_page.dart';

void main(List<String> args) {
  runApp(MaterialApp(
      home: HomePage(), //Aqui a Pagina que sempre vai ser chamada ao iniciar o App
      theme: ThemeData(
          hintColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ))));
}
