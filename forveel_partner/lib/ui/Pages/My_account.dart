import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/Internet/check_network_connection.dart';
import 'package:forveel_partner/Resources/Internet/internetpopup.dart';
import 'package:forveel_partner/Resources/themes/light_color.dart';
import 'package:forveel_partner/Resources/ui/MechanicPageVidgets.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import 'package:url_launcher/url_launcher.dart';


class MechanicPageUID extends StatefulWidget {

  DocumentSnapshot data;
MechanicPageUID(this.data);
  @override
  _MechanicPageUIDState createState() => _MechanicPageUIDState();
}

class _MechanicPageUIDState extends State<MechanicPageUID> {
  DocumentSnapshot _mechanic;
  StreamSubscription<DocumentSnapshot> subscription;

  @override
  void initState() {
    _mechanic=widget.data;
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
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: LightColor.lightGrey,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title:  Text("My Account",
          style: GoogleFonts.lato(
          color: LightColor.lightblack,
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
          decoration: BoxDecoration(
            color: LightColor.black
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 8,sigmaX: 8),
              child: ListView(
                children: <Widget>[

                  Center(child: VtypesShow(_mechanic['vehicle_type'],_mechanic['Two wheeler'],_mechanic['Four wheeler'])),
                  SizedBox(height: 15,),
                  Skills(_mechanic['types']),
                  SizedBox(height: 15,),
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
              ListTile(
                title: Text(_mechanic['email'],style: GoogleFonts.lato(color: grey),),
                leading: Icon(Icons.email,color: grey,),
              ),
                  ListTile(
                title: Text(_mechanic['phone'],style: GoogleFonts.lato(color: grey),),
                leading: Icon(Icons.phone,color: grey,),
              ) ,
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
                  SizedBox(height: 15,),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.personBooth,color: LightColor.orange,),
                    title: Text("Experiance: ${_mechanic['exp']} years",
                      style: GoogleFonts.lato(
                          color: background
                      ),
                    ),
                  ),      Container(
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


                ],
              ),
            ),
          ),
        ),
      ),





    );
  }




_refreshavalability() async{

  subscription=Firestore.instance.collection('mechanic').document(_mechanic.documentID).snapshots().listen((event) {
    if(event.exists){
      if(!mounted) return;
      setState(() {
        _mechanic=event;
      });
    }
  });
}


@override
  void dispose() {
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}
