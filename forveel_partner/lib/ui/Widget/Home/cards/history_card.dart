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
import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Mycolors.dart';
import '../../../loader_dialog.dart';

class HistoryCard extends StatefulWidget {
DocumentSnapshot data;
HistoryCard(this.data);
  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {

  String formatted="";
  @override
  void initState() {
    formatted = formatTime(int.parse(widget.data['datetime']));
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
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset.zero,
                    color: Colors.grey.withOpacity(0.5)
                )]
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
                              style: TextStyle(
                                  color: Colors.black45,
                                fontWeight: FontWeight.bold
                              ),

                            ),
                            Text(
                                "Issue: ${widget.data['issue']}",
                                style: TextStyle(
                                    color: Colors.black
                                )
                            ),Text(
                                "Location: ${widget.data['address']}",
                                style: TextStyle(
                                    color: textc
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Status: "+widget.data['status'].toString().replaceAll("you", "user"),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54
                                    )
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.av_timer,color: voilet),
                                    Text(formatted,
                                      style: TextStyle(
                                          color: voilet
                                      ),

                                    ),
                                  ],
                                ),
                              ],
                            ),


                                Container(
                          child:   Card(
                            child: Container(
                              child: IconButton(
                                icon: Icon(Icons.info,color: background,),
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
                                ),

                          ], // end of Column Widgets
                        ),  // end of Column
                      ),
                      onTap:(){
                        if(!widget.data['isreviewed']){return;}
                        showDialog(context: context,
                        builder: (context){

                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)
                            ),
                            title: Text("Rating and review",style: TextStyle(
                              color: grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 15
                            ),
                            textAlign: TextAlign.center,
                            ),
                            content: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                        int.parse(widget.data['rating'].toString().split(".")[0]).floor(),
                                            (index){
                                          return Icon(Icons.star,color: Colors.yellow);
                                            }),
                                  ),
                                  SizedBox(height: 7,),
                                  Text(widget.data['review'],style: TextStyle(color: grey)),
                                  SizedBox(height: 6),
                                  Text("Rs. ${widget.data['charges']}",style: TextStyle(color: voilet),),
                                ],
                              ),
                            ),

                          );
                        }
                        );

                      }
                  ),  // end of Container
                ),
                // third w// idget
              ]
          )
      ),

    );
  }




}



