import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/puncturehome.dart';
import 'package:forveel_partner/ui/Start/completedetails/completedetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'home.dart';

class waiting extends StatefulWidget {
  DocumentSnapshot data;
  waiting(DocumentSnapshot snapshot){
    data=snapshot;
  }
  @override
  _waitingState createState() => _waitingState();
}

class _waitingState extends State<waiting> {
  DocumentSnapshot mydata;
  StreamSubscription<DocumentSnapshot> _subscription;
  @override
  void initState() {
    mydata=widget.data;
    _refresh();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 50, 0, 0),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.markunread,color: green,),
                    Text("Successfully Applied",style: GoogleFonts.lato(color: green,fontSize: 20),),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text("Your have successfully applied for the forveel partner account."
                    "Our service executive will contact you soon on ${widget.data['phone']}. You can fill the complete details"
                    "by clicking the button below.",
                style: GoogleFonts.lato(color: grey),
                ),
              ),
              (mydata['name']=="null" && !mydata["onlypuncture"])?OutlineButton(
                borderSide: BorderSide(color: voilet),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.format_align_center,color: voilet,),
                    Text("Complete your details",style: GoogleFonts.lato(color: voilet),),
                  ],
                ),
                onPressed: (){
                  Navigator.push(context, PageTransition(
                    child: CompleteDetails(mydata),
                    duration: Duration(milliseconds: 50),
                    type: PageTransitionType.upToDown
                  ));
                },
              ):
              OutlineButton(
                borderSide: BorderSide(color: green),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.cloud_upload,color: green,),
                    Text("Details submitted successfully",style: GoogleFonts.lato(color: green),),
                  ],
                ),
                onPressed: (){
                },
              )
            ],
          ),
        )
      ),
    );
  }


  _refresh() async{
    if(!mounted) return;
  _subscription = Firestore.instance.collection('mechanic').document(widget.data.documentID).snapshots().listen((event) {
      if(event.exists){
       if(event['verified']){
         if(event["onlypuncture"]){
           Navigator.push(context, PageTransition(
               child: PunctureHome(event),
               duration: Duration(milliseconds: 200),
               type: PageTransitionType.scale,
               alignment: Alignment.center
           ));
         }else{
           Navigator.push(context, PageTransition(
               child: Home(event),
               duration: Duration(milliseconds: 200),
               type: PageTransitionType.scale,
               alignment: Alignment.center
           ));
         }
       }else{
         setState(() {
           mydata=event;
         });
       }
      }
    });
  }
@override
  void dispose() {
    _subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}
