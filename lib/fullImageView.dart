import 'dart:async';
import 'package:animefy/Utils/lottieAnim.dart';
import 'package:lottie/lottie.dart';
import 'package:animefy/Loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';





class ImageView extends StatefulWidget {
  var _id,_link,_name=new DateTime.now().millisecondsSinceEpoch.toString();
  var flag = false;
  var is_working=false;
  var is_permitted=false;
  var result;
  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  var _isOnline=true;
  StreamSubscription<ConnectivityResult> subscription;
  static const platform = MethodChannel("set_wallpaper");

  ImageView(this._id, this._link);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {



  //Native Api Call For Android
  void _setWallPaperNative(String filePath) async
  {
    var result = await ImageView.platform.invokeListMethod("getWallPaper",{"url":filePath});
  }

  void downloadImage() async
  {
    setState(() {
      widget.is_working=true;
    });
    print("Downloading");
    var response = await Dio().get(
        widget._link,
        options: Options(responseType: ResponseType.bytes));
    widget.result  = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: widget._name);
    print( widget.result );

    setState(() {
      widget.is_working=false;
    });
  }
  void setWallpaper() async
  {
    setState(() {
      widget.is_working=true;
    });
    print("Setting Wallpaper");
    var response = await Dio().get(
        widget._link,
        options: Options(responseType: ResponseType.bytes));
    widget.result  = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: widget._name);

    print( widget.result );

    _setWallPaperNative( widget.result);

    setState(() {
      widget.is_working=false;
    });
  }




  //Asking Permissions
  void _askPermission()
  {
    PermissionHandler().requestPermissions([PermissionGroup.storage]).then(_onPermissionRequested);
  }

  //Download File If Permission Is Given
  void _onPermissionRequested(Map<PermissionGroup,PermissionStatus> statuses) async
  {

    final status = statuses[PermissionGroup.storage];
    if(status != PermissionStatus.granted)
    {
      PermissionHandler().openAppSettings();
    }
    else
    {
      widget.is_permitted=true;
    }
  }

  //Share Image
  void _onImageShareButtonPressed() async {

    var request = await HttpClient().getUrl(Uri.parse(widget._link));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('Download This Awesome Walpapaer For Your Phone', widget._name+".jpg", bytes, 'image/jpg');
  }

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





  @override
  void initState() {
    // TODO: implement initState
    checkInternet();
   _askPermission();
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
      body: Container(
        child: widget._isOnline==true?Stack(
          children: <Widget>[
            Hero(tag:widget._id,child: Image.network(
              widget._link,
              fit: BoxFit.cover,
              height: double.maxFinite,
              alignment: Alignment.center,
            ),), // Hero Animation
            Container(
              margin: EdgeInsets.fromLTRB(8, 30, 0, 0),
              child: IconButton(icon: Icon(Icons.arrow_back,size: 30,color: Colors.white),
                onPressed: (){Navigator.pop(context);},),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  button("tag1",Icons.arrow_downward,Colors.red,(){

                    _askPermission();
                    if(widget.is_permitted)
                      {
                        downloadImage();
                      }
                  }),
                  SizedBox(width: 10,),
                  button("tag2",Icons.wallpaper,Colors.red,(){

                    _askPermission();
                    if(widget.is_permitted)
                    {
                      setWallpaper();
                    }
                  }),
                  SizedBox(width: 10,),
                  button("tag3",Icons.share,Colors.red,(){
                    _onImageShareButtonPressed();
                  }),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            widget.is_working?Center(
              child: loading(),
            ):SizedBox()
          ],
        ):lottieAnim(),
      ),
    );
  }
}

//Buttons
class button extends StatelessWidget {
  var tag,icon,color,onpressed;
  button(this.tag,this.icon,this.color,this.onpressed)
  {
    tag=tag;
    icon=icon;
    color=color;
    onpressed=onpressed;
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.bottomRight,
      child:  FloatingActionButton(
        heroTag: tag,
        backgroundColor: color,
        onPressed: onpressed,
        child: Icon(icon),
      ),
    );;;
  }


}


//Loading Screen
Widget loading()
{
  return Container(
    height: 150,
    width: 200,
    child: Card(
      child: Column(
        children: <Widget>[
          SizedBox(height: 15,),
          Loader(),
          SizedBox(height: 5,),
        ],
      ),
    ),
  );
}
