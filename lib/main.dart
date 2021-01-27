import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animefy/Loader.dart';
import 'package:animefy/ModelClass/images.dart';
import 'package:animefy/Utils/lottieAnim.dart';
import 'package:animefy/brandName.dart';
import 'package:animefy/fullImageView.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  var _images = List<images>();
  var _theme = 0;
  var _isOnline=true;
  var _connectionStatus = 'Unknown';
  bool _isFirst = true;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  String _api = "https://androdude.com/anime_fy.json";



  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {
var j=0;
var random = new Random();

//Shuffle The List
List<images> shuffle(List<images> items) {

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

//Get The Images From Server
void getImages() async
{
  setState(() {
    widget._isFirst=true;
  });
   try{
     var response  = await http.get(widget._api);
     for(var i in json.decode(response.body))
     {
       setState(() {
         widget._images.add(images(i,i));
       });
     }
     setState(() {
       widget._images=shuffle(widget._images);
     });
   }
   on HttpException catch(error)
  {
    print(error);
  }

  setState(() {
    widget._isFirst=false;
  });
}

//Check If Internet Is Available
void checkInternet()
{
  widget.connectivity = new Connectivity();
  widget.subscription =
      widget.connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        widget._connectionStatus = result.toString();
        print(widget._connectionStatus);
        if (result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) {
          setState(() {
            changeTheme();
            getImages();
            widget._isOnline=true;
          });
        }
        else
          {
            setState(() {
              widget._isOnline=false;
            });
          }
      });
}





void changeTheme()
{
  var n = random.nextInt(0 + 2);
  widget._theme=n;
}





  
  @override
  void initState() {
    // TODO: implement initState
    checkInternet();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.subscription.cancel();
    super.dispose();
  }
  
  
  @override

  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body:Container(
        child:widget._isOnline==true?widget._isFirst==true?Center(child: Loader()):widget._theme==0?gridImages(widget._images, context):GridImages(widget._images, context):lottieAnim() ,
      ),
    );
  }
}

Widget gridImages(List<images> images,BuildContext context)
{
  return Container(

    margin: EdgeInsets.all(5),
    child: StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: images.length,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      staggeredTileBuilder: (index)=>StaggeredTile.count(1, index.isEven?1.2:1.0),
      itemBuilder: (context,index)
      {
        return Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageView(images[index].id,images[index].link)),
                  );
                },
                child: Hero(tag:images[index].id,child: Image.network(images[index].link,height: 50,width: 100,fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress)
                       {
                          if (loadingProgress == null) return child;
                                     return Center(
                                      child: Loader(),);
                                    },),),

          ),
        ));
      },
    ),
  );
}

Widget GridImages(List<images> images,BuildContext context)
{
  return Container(

    padding: EdgeInsets.only(bottom: 10,left: 13,right: 13),
    child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 6.0,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: images.map((e) =>
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:  GridTile(
                    child: GestureDetector(
                      onTap: ()
                      {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImageView(e.id,e.link)),
                      ); },
                      child: GridTile(
                        child:
                        Container(
                          child: Hero(tag:e.id,child: Image.network(e.link,height: 50,width: 100,fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress)
                            {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Loader(),
                              );
                            },),),
                        ),
                      ),
                    )
                ))
        ).toList()
    ),
  );
}


//SingleChildScrollView(
//child: Column(
//children: <Widget>[
//Container(
//child: Row(
//mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//SizedBox(height: 8,),
//Text("Made in",style: TextStyle(color: Colors.black),),
//SizedBox(width: 5,),
//Text("India",style: TextStyle(color: Colors.red),),
//],
//),
//),
//SizedBox(height: 30,),
//widget._isOnline==true?widget._theme==0?gridImages(widget._images, context):GridImages(widget._images, context):lottieAnim()
//],
//),
//)

