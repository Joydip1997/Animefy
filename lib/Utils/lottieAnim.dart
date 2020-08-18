import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

Widget lottieAnim()
{
  return Center(
    child: Container(
      height: 300,
      width: 300,
      child:Lottie.asset("assets/lottie.json",
          height: 300,
          width: 300,
          fit: BoxFit.cover) ,
    ),
  );
}




