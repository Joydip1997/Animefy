import 'package:flutter/material.dart';
import 'dart:math';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {

  AnimationController controler;
  Animation<double> animationIn;
  Animation<double> animationOut;
  Animation<double> animationRotation;

  final double initualRadius = 35;
  double Radius = 0;


  @override
  void initState() {
    // TODO: implement initState
    controler=AnimationController(vsync: this,duration: Duration(seconds: 5));

    animationIn = Tween<double>(
        begin: 1.0,
        end: 0.0
    ).animate(CurvedAnimation(parent: controler, curve: Interval(0.75, 1.0,curve: Curves.elasticIn)));

    animationOut = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(CurvedAnimation(parent: controler, curve: Interval(0.0, 0.25,curve: Curves.elasticOut)));

    animationRotation  = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(CurvedAnimation(parent: controler, curve: Interval(0.0, 1.0,curve: Curves.linear)));

    controler.addListener(() {
      setState(() {
        if(controler.value >= 0.75 && controler.value <=1.0)
        {
          Radius=animationIn.value*initualRadius;
        }
        else if(controler.value >= 0.0 && controler.value <=0.25)
        {
          Radius=animationOut.value*initualRadius;
        }
      });
    });


    controler.repeat();


    super.initState();
  }

  @override
  void dispose() {
    controler.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Center(
        child: RotationTransition(
          turns: animationRotation,
          child: Stack(
            children: <Widget>[
              Dot(30,Colors.black12),
              Transform.translate(
                  offset: Offset(Radius*cos(pi/4),Radius*sin(pi/4)),
                  child: Dot(5,Colors.redAccent)),
              Transform.translate(
                  offset: Offset(Radius*cos(2*pi/4),Radius*sin(2*pi/4)),
                  child: Dot(5,Colors.green)),
              Transform.translate(
                  offset: Offset(Radius*cos(3*pi/4),Radius*sin(3*pi/4)),
                  child: Dot(5,Colors.black)),
              Transform.translate(
                  offset: Offset(Radius*cos(4*pi/4),Radius*sin(4*pi/4)),
                  child: Dot(5,Colors.yellow)),
              Transform.translate(
                  offset: Offset(Radius*cos(5*pi/4),Radius*sin(5*pi/4)),
                  child: Dot(5,Colors.blue)),
              Transform.translate(
                  offset: Offset(Radius*cos(6*pi/4),Radius*sin(6*pi/4)),
                  child: Dot(5,Colors.red)),
              Transform.translate(
                  offset: Offset(Radius*cos(7*pi/4),Radius*sin(7*pi/4)),
                  child: Dot(5,Colors.greenAccent)),
              Transform.translate(
                  offset: Offset(Radius*cos(8*pi/4),Radius*sin(8*pi/4)),
                  child: Dot(5,Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;


  Dot(this.radius, this.color);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle
        ),
      ),
    );
  }
}

