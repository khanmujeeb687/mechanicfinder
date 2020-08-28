import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'complete_service.dart';

class USCard extends StatefulWidget {
  DocumentSnapshot data;
  Position position;
  USCard(this.data,this.position);
  @override
  _USCardState createState() => _USCardState();
}

class _USCardState extends State<USCard> {
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
              color: background,
          ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(widget.data['status'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: green
                                    )
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.av_timer,color: voilet),
                                    Text(formatted,
                                      style: GoogleFonts.lato(
                                          color: voilet
                                      ),

                                    ),
                                  ],
                                ),
                              ],
                            ),
                           loading?Container(child: SpinKitThreeBounce(color: voilet,),):Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             mainAxisSize: MainAxisSize.max,
                             children: <Widget>[
                               Card(
                                 child: Container(
                                   child: IconButton(
                                     icon: Icon(Icons.done,color: background,),
                                     onPressed: (){
                                       showDialog(context: context,
                                       builder: (context){
                                         return AlertDialog(
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(40)
                                           ),
                                           title: Text("Current status - ${widget.data['status']}",style: TextStyle(
                                             color: grey,
                                             fontWeight: FontWeight.w400,
                                             fontSize: 15
                                           ),
                                           textAlign:TextAlign.center,
                                           ),
                                           content: Container(
                                             width: MediaQuery.of(context).size.width/2,
                                             height: MediaQuery.of(context).size.height/3,
                                             child: ListView(
                                               children: <Widget>[


                                                 (widget.data['status']=="accepted")?
                                                 RaisedButton(
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                   child: Text("Out for pickup",style: GoogleFonts.lato(color: background),),
                                                   color: skin,
                                                   onPressed: ()async{
                                                     Navigator.pop(context);

                                                     setState(() {
                                                       loading=true;
                                                     });
                                                     Firestore.instance.collection('service').document(widget.data.documentID).updateData({
                                                       "status":"out for pickup",
                                                       "datetime":DateTime.now().millisecondsSinceEpoch.toString()
                                                     }).then((value) {
                                                       setState(() {
                                                         loading=false;
                                                       });
                                                     });
                                                   },
                                                   elevation: 10,
                                                 ):
                                                     Container(),



                      (widget.data['status']=="out for pickup")? RaisedButton(
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                   child: Text("Picked up",style: TextStyle(color: background),),
                                                   color: grey,
                                                   onPressed: ()async{
                                                     Navigator.pop(context);

                                                     setState(() {
                                                       loading=true;
                                                     });
                                                     Firestore.instance.collection('service').document(widget.data.documentID).updateData({
                                                       "status":"picked up",
                                                       "datetime":DateTime.now().millisecondsSinceEpoch.toString()
                                                     }).then((value) {
                                                       setState(() {
                                                         loading=false;
                                                       });
                                                     });
                                                   },
                                                   elevation: 10,
                                                 ):
                                                     Container(),

                                                 (widget.data['status']=="picked up")? RaisedButton(
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                   child: Text("Repaired",style: TextStyle(color: background),),
                                                   color: grey,
                                                   onPressed: ()async{
                                                     Navigator.pop(context);

                                                     setState(() {
                                                       loading=true;
                                                     });
                                                     Firestore.instance.collection('service').document(widget.data.documentID).updateData({
                                                       "status":"repaired",
                                                       "datetime":DateTime.now().millisecondsSinceEpoch.toString()
                                                     }).then((value) {
                                                       setState(() {
                                                         loading=false;
                                                       });
                                                     });
                                                   },
                                                   elevation: 10,
                                                 ):
                                                     Container(),

                                                 (widget.data['status']=="accepted" || widget.data['status']=="repaired")? RaisedButton(
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                   child: Text("Service Complete",style: TextStyle(color: background),),
                                                   color: grey,
                                                   onPressed: ()async{
                                                     Navigator.pop(context);
                                                    Map result=await Navigator.push(context, PageTransition(
                                                       child: CompleteService(widget.data),
                                                     ));
                                                    if(result["status"]=="success")
                                                      {

                                                      }
                                                   },
                                                   elevation: 10,
                                                 ):
                                                 Container(),




                                                 (widget.data['status']=="accepted")? RaisedButton(
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                   child: Text("Cancel request",style: TextStyle(color: background),),
                                                   color: pink,
                                                   onPressed: ()async{
                                                     Navigator.pop(context);
                                                     setState(() {
                                                       loading=true;
                                                     });
                                                     Firestore.instance.collection('service').document(widget.data.documentID).updateData({
                                                       "status":"cancelled by mechanic",
                                                       "datetime":DateTime.now().millisecondsSinceEpoch.toString()
                                                     }).then((value) {
                                                       setState(() {
                                                         loading=false;
                                                       });
                                                     });
                                                   },
                                                   elevation: 10,
                                                 ):
                                                     Container(),



                                               ],
                                             ),
                                           ),
                                         );
                                       }
                                       );
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
                               ),    Card(
                                 child: Container(
                                   child: IconButton(
                                     icon: Icon(Icons.contact_phone,color: background,),
                                     onPressed: (){
                                       showDialog(context: context,
                                       builder: (context){{
                                         return AlertDialog(
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(40)
                                           ),
                                     title: Text("Contact customer",textAlign: TextAlign.center,style: TextStyle(color: voilet,fontSize: 15,fontWeight: FontWeight.w400),),
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
                                                         String url = "tel:${widget.data['phone']}";
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
                                                         String url = "sms:+91 ${widget.data['phone']}";
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
                                                     String url = "whatsapp://send?phone=+91 ${widget.data['phone']}";
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
                           )
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
                        Text("Route",style: TextStyle(fontSize: 10,color: background),)
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


