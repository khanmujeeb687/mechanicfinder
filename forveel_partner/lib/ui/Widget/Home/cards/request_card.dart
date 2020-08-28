import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/Internet/check_network_connection.dart';
import 'package:forveel_partner/Resources/Internet/internetpopup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';


import '../../../Mycolors.dart';
import '../../../loader_dialog.dart';

class RequestCard extends StatefulWidget {
 DocumentSnapshot data;
 Position position;
 RequestCard(this.data,this.position);
  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool loading;
  String formatted;
  @override
  void initState() {
    formatted = formatTime(int.parse(widget.data['datetime']));
    loading=false;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      color: background,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child:  Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: background),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Expanded(
                  child: GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Text("vehicle :${widget.data['uservehicle']}",
                          style: GoogleFonts.lato(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold
                          ),

                        ),
                           Text("Issue: ${widget.data['issue']}",
                          style: GoogleFonts.lato(
                          color: Colors.black
                           )),
                            Text(
                            "Location: ${widget.data['address']}",
                           style: GoogleFonts.lato(
                          color: textc
          )
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.av_timer,color: voilet),
                                Text(formatted,
                                  style: TextStyle(
                                      color: voilet
                                  ),

                                ),
                              ],
                            ),
                            loading?Container(
                              child: SpinKitThreeBounce(
                                color: voilet,
                              ),
                            ):Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: Text("Accept",style: TextStyle(color: background),),
                                  color: green,
                                  onPressed: ()async{
                                    setState(() {
                                      loading=true;
                                    });
                                    Firestore.instance.collection('service').document(widget.data.documentID).updateData({
                                      'status':'accepted',
                                      "datetime":DateTime.now().millisecondsSinceEpoch.toString()
                                    }).then((value) {
                                      if(!mounted) return;
                                      setState(() {
                                        loading=false;
                                      });
                                    });
                                  },
                                  elevation: 10,
                                ), RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: Text("Reject",style: TextStyle(color: background),),
                                  color: pink,
                                  onPressed: ()async{
                                    setState(() {
                                      loading=true;
                                    });
                                    Firestore.instance.collection('service').document(widget.data.documentID).updateData({
                                      'status':'cancelled by mechanic',
                                      "datetime":DateTime.now().millisecondsSinceEpoch.toString()
                                    }).then((value) {
                                      setState(() {
                                        loading=false;
                                      });
                                    });
                                  },
                                  elevation: 10,
                                ),
                              ],
                            ),
                          ], // end of Column Widgets
                        ),  // end of Column
                      ),
                      onTap:(){

                      }
                  ),  // end of Container
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.directions,color: myyellow,),
                        Text("Location",style: TextStyle(fontSize: 10,color: voilet),)
                      ],
                    ),
                  ),
                  onTap:(widget.position!=null)?_launchMapsUrl:Scaffold.of(context).showSnackBar(SnackBar(content: Text("problem starting navigation"),)),
                )

                // third w// idget
              ]
          )
      ),

    );
  }

  void _launchMapsUrl() async {
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    final url = 'https://www.google.com/maps/dir/?api=1&origin=${widget.position.latitude},${widget.position.longitude}&destination=${widget.data['lat']},${widget.data['long']}&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}


