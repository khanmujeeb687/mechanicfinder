import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:forveel/Resources/themes/light_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/Resources/ui/MechanicPageVidgets.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Widgets/Home/Photoview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../loader_dialog.dart';
import 'history_page.dart';
import 'home.dart';

class MechanicUpdatePage extends StatefulWidget {
  String mid;
  String status;
  String rid;
  String issue;
 String uservehicle;
  MechanicUpdatePage(this.mid,this.status,this.rid,this.issue,this.uservehicle);
  @override
  _MechanicUpdatePageState createState() => _MechanicUpdatePageState();
}

class _MechanicUpdatePageState extends State<MechanicUpdatePage> {
  Position _position;
  String distance="";
  bool load;
  DocumentSnapshot _mechanic;
  String status;
  StreamSubscription<DocumentSnapshot> subscription;
  StreamSubscription<DocumentSnapshot> subscriptiontwo;
  @override
  void initState() {
    this.status=widget.status;
    load=false;
    _Loadmechanic();
    _refreshavalability();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body:NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: background,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Service Update",
                      style: GoogleFonts.lato(
                        color: LightColor.darkgrey,
                        fontSize: 16.0,
                      )),
                  background: CachedNetworkImage(
                    imageUrl: _mechanic['photo'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: Container(
          child: (load)?Container(
            decoration: BoxDecoration(
              color: LightColor.black
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 8,sigmaX: 8),
                child: ListView(
                  children: <Widget>[
                    Center(child: VtypesShow(_mechanic['vehicle_type'],_mechanic['Two wheeler'],_mechanic['Four wheeler'])),
                    SizedBox(height: 10,),
                    Skills(_mechanic['types']),
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: green.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                              "Status: ${status}"
                              ,
                              style: GoogleFonts.lato(
                                  color: background,
                                  fontSize: 20
                              ),
                            ),
                          ),     Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                              "Issue: ${widget.issue}"
                              ,
                              style: GoogleFonts.lato(
                                  color: background,
                                  fontSize: 16
                              ),
                            ),
                          ),  Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                              "Vehicle: ${widget.uservehicle}"
                              ,
                              style: GoogleFonts.lato(
                                  color: background,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    ,
                    (status!="pending")?Container(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        color: myyellow,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.call,color: green,size: 35,),
                              onPressed: (){},
                            ),
                            Text("Contact forveel partner",style: GoogleFonts.lato(color: background),)
                          ],
                        ),
                        onPressed: (){
                          showDialog(context: context,
                              builder: (context){{
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)
                                  ),
                                  title: Text("Contact forveel partner",textAlign: TextAlign.center,style: TextStyle(color: voilet,fontSize: 15,fontWeight: FontWeight.w400),),
                                  content: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Card(
                                          child: Container(
                                            child: IconButton(
                                              icon: Icon(Icons.call,color: background,),
                                              onPressed: ()async{
                                                String url = "tel:${_mechanic['phone']}";
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.blue.shade300,
                                            ),
                                            width: 50,
                                            height: 50,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        Card(
                                          child: Container(
                                            child: IconButton(
                                              icon: Icon(Icons.sms,color: background,),
                                              onPressed: ()async{
                                                String url = "sms:+91 ${_mechanic['phone']}";
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: grey,
                                            ),
                                            width: 50,
                                            height: 50,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        Card(
                                          child: Container(
                                            child: IconButton(
                                              icon: Icon(FontAwesomeIcons.whatsapp,color: background,),
                                              onPressed: () async{
                                                String url = "whatsapp://send?phone=+91 ${_mechanic['phone']}";
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: green,
                                            ),
                                            width: 50,
                                            height: 50,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }});
                        },
                      ),
                    ):Container( ),
                    SizedBox(height: 15,),
                    ListTile(
                      leading: Icon(_mechanic['pickup']?FontAwesomeIcons.check:Icons.error,color: LightColor.orange,),
                      title: Text(_mechanic['pickup']?"Provides pickup from your location":"Does not picks ups your vehicle from location",style: GoogleFonts.lato(
                          color: background
                      ),),
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.airline_seat_recline_extra,color: LightColor.orange,),
                      title: Text("Services",style: GoogleFonts.lato(color: background),),
                      children:List.generate(_mechanic['services'].length, (index){
                        return ListTile(
                          onLongPress: (){
                          },
                          title: Text(_mechanic['services'][index]['name'],style: GoogleFonts.lato(color: grey,fontWeight: FontWeight.w600),),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Rs. ${_mechanic['services'][index]['price']}",style: GoogleFonts.lato(color: grey,decoration: TextDecoration.lineThrough,fontWeight: FontWeight.w400,letterSpacing: 1),),
                              Text((){
                                return "Rs.${
                                    double.parse(_mechanic['services'][index]['price'])-((double.parse(_mechanic['services'][index]['price'])*double.parse(_mechanic['services'][index]['off']))/100)
                                }";
                              }(),
                                style: GoogleFonts.lato(color: green,fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          trailing: Text("${_mechanic['services'][index]['off']}% OFF",style: GoogleFonts.lato(color: pink),),
                        );
                      }),
                    ),
                    Divider(height: 1,),
                    SizedBox(height: 15,),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.user,color: LightColor.orange,),
                      title: Text("${_mechanic['name']} ",
                        style: GoogleFonts.lato(
                            color: background
                        ),),
                      trailing:  Column(
                        children: <Widget>[
                          (!_mechanic['online'])?Icon(FontAwesomeIcons.solidCircle,color: Colors.red,):Icon(FontAwesomeIcons.solidCircle,color: green,),
                          Text( (_mechanic['online'])?"Available":"Unavailable",style:GoogleFonts.lato(
                              color: background
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.home,color: LightColor.orange,),
                      title: Text("${_mechanic['shopname']}",style: GoogleFonts.lato(
                          color: background
                      ),),
                    ),
                    SizedBox(height: 15,),
                    ListTile(
                      leading: Icon(Icons.location_on,color: LightColor.orange,),
                      title: Text("${_mechanic['address']}",style: GoogleFonts.lato(
                          color: background,
                          fontSize: 14
                      ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Text("Distance: ${distance} Km's",style: GoogleFonts.lato(
                          color: background
                      ),),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Text("${_mechanic['address']}",style: GoogleFonts.lato(
                              color: background,
                            ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(icon: Icon(Icons.directions,color: pink),color: pink,
                                onPressed:_launchMapsUrl,
                              ),
                              Text("Get Directions",style: GoogleFonts.lato(
                                  color: background
                              ),),
                            ],
                          )
                        ],
                      ),
                    ),   Container(
                      margin: EdgeInsets.all(20),
                      child: Text("Experiance: ${_mechanic['exp']} years",
                        style: GoogleFonts.lato(
                            color: background
                        ),
                      ),
                    ),   Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        children: List.generate(int.parse(_mechanic['rating']['value'].toString().split(".")[0]).floor(), (index){
                          return Icon(FontAwesomeIcons.solidStar,color: Colors.yellow,);
                        }),
                      ),
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      leading: Icon(Icons.wrap_text,color: LightColor.orange,),
                      title: Text(
                        "${_mechanic['desc']}"
                        ,
                        style: GoogleFonts.lato(
                            color: background
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(20),
                      child: (status=="pending" || status=="accepted")?RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        color: grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.delete,color: background),
                            SizedBox(width: 10,),
                            Text("Cancel this request",style: GoogleFonts.lato(color: background),)
                          ],
                        ),
                        onPressed: _cancelrequest,
                      ):Text("",style: GoogleFonts.lato(
                          color: Colors.grey
                      ),),
                    ),

                  ],
                ),
              ),
            ),
          ):Center(
            child: SpinKitThreeBounce(
              color: myyellow,
            ),
          ),
        ),
      ),





    );
  }

  _refreshavalability() async{
   subscription = Firestore.instance.collection('mechanic').document(widget.mid).snapshots().listen((event) {
      if(event.exists){
        if(!mounted) return;

        setState(() {
          _mechanic=event;
        });
      }
    });
   subscriptiontwo = Firestore.instance.collection('service').document(widget.rid).snapshots().listen((event) {
      if(event.exists){
        setState(() {
          status=event['status'];
        });
      }
    });
  }

  _Loadmechanic() async{
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    Firestore.instance.collection('mechanic').document(widget.mid).get().then((value){
     setState(() {
       if(!mounted) return;
       _mechanic=value;
       load=true;
     });
    });
    getcurrentlocation();

  }


  _fill_distance() async{
    double distanceInMeters = await new Geolocator().distanceBetween(_position.latitude,_position.longitude,
        double.parse(_mechanic['lat'].toString()), double.parse(_mechanic['long'].toString()));
    setState(() {
      distance=(distanceInMeters/1000).toStringAsFixed(2);
    });
  }

  getcurrentlocation() async{
    _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(_position==null){
      _position=await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    }
    _fill_distance();
  }



  void _launchMapsUrl()   async {
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    final url = 'https://www.google.com/maps/dir/?api=1&origin=${_position.latitude},${_position.longitude}&destination=${_mechanic['lat']},${_mechanic['long']}&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void _cancelrequest() async{
    TextEditingController _controller=new TextEditingController();

    showDialog(
        barrierDismissible: false, context: context, builder: (context) {
      return Container(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0,sigmaY: 5.0),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
            ),
              elevation: 10,
              backgroundColor: background,
              content: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      style: GoogleFonts.lato(
                        color: grey
                      ),
                      controller: _controller,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: InputDecoration(
                          hintText: "Explain reason.."
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      color: pink,
                      child: Text(
                        "Cancel request", style: GoogleFonts.lato(color: background),),
                      onPressed: () {
                        if (_controller.text == "") {
                          Toast.show("Please write something!", context,gravity: Toast.CENTER);
                          Vibration.vibrate(duration:200);
                        }
                        else {
                          _cancelit(_controller.text);
                        }
                      },
                    )
                  ],
                ),
              )
          ),
        ),
      );
    }  );


  }

  _cancelit(text)
  async{
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    LoaderDialog(context, false);
    Firestore.instance.collection("service").document(widget.rid).updateData({
      "status":"cancelled by you",
      "datetime":DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value){
      if(!mounted) return;
      Toast.show("Successfully cancelled", context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

    });

  }

@override
  void dispose() {
    subscriptiontwo.cancel();
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }



}
