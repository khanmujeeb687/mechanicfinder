import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/home.dart';
import 'package:http/http.dart';

class online extends StatefulWidget {
  @override
  _onlineState createState() => _onlineState();
}

class _onlineState extends State<online> {
bool val;
String status;
bool loading;
@override
  void initState() {
    // TODO: implement initState
  val=Home.userdata['online'];
  loading=false;
  if(val){
    status="Open";
  }else{
    status="Close";
  }
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return !loading?Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
hoverColor: green,
          activeColor: green,
          inactiveThumbColor: voilet,
          inactiveTrackColor: voilet,
          value: val,
          onChanged: (a){
           _changestatus();
          },
        ),
        Text(status,style: TextStyle(color: textc,letterSpacing: 2,fontWeight: FontWeight.w400),)
      ],
    ):Container(
      child: SpinKitThreeBounce(
        color: textc,
        size: 15,
      ),
    );
  }

  _changestatus() async{
  setState(() {
    loading=true;
  });
bool mystatus;
  if(val){
    mystatus=false;
  }
  else{
     mystatus=true;
  }
  Firestore.instance.collection('mechanic').document(Home.userdata.documentID).updateData({
    "online":mystatus
  }).then((value){
  setState(() {
    val=val?false:true;
    status=(status=="Open")?"Close":"Open";
    loading=false;
  });
});


  }


}
