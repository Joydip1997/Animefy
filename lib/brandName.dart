import 'package:flutter/material.dart';

Widget brandName()
{
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Anime",style: TextStyle(color: Colors.black),),
        Text("fy",style: TextStyle(color: Colors.redAccent),),
      ],
    ),
  );
}