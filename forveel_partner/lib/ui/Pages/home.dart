import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/themes/light_color.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Start/Login/Login.dart';
import 'package:forveel_partner/ui/Widget/Home/Drawer.dart';
import 'package:forveel_partner/ui/Widget/Home/online.dart';
import 'package:forveel_partner/ui/Widget/Home/request.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static DocumentSnapshot userdata;
  Home(DocumentSnapshot snapshot){
    userdata=snapshot;
  }
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   Position _position;
   List<DocumentSnapshot> _data;
   bool loading;
   var locationOptions;
   StreamSubscription<Position> positionStream;
   var geolocator = Geolocator();
   List<bool> filter=[true,true,true];
   List<int> counts=[0,0,0];
   StreamSubscription<QuerySnapshot> _subscription;

   @override
  void initState() {
     loading=true;
    locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
          if(position!=null){
              _position=position;
          }
        });
    _getcurrentlocation();
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
        drawer: drawer(),
        appBar: AppBar(
          iconTheme: new IconThemeData(color: LightColor.orange),
          backgroundColor: LightColor.black,
          title: online(),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child:ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    CountsContainer(text:"All",counts:(counts[0]+counts[1]+counts[2]).toString(),icon:Icons.all_inclusive,active:filter.contains(false)?false:true,ontap: (){
                      setState(() {
                        filter[0]=true;
                        filter[1]=true;
                        filter[2]=true;
                      });
                    },),
                    CountsContainer(text:"Requests",counts:counts[0].toString(),icon:Icons.call,active: (filter.contains(false) && filter[0])?true:false,ontap: (){
                      setState(() {
                        filter[0]=true;
                        filter[1]=false;
                        filter[2]=false;
                      });
                    },),
                    CountsContainer(text:"Under service",counts:counts[1].toString(),icon:Icons.network_locked,active: (filter.contains(false) && filter[1])?true:false,ontap: (){
                      setState(() {
                        filter[0]=false;
                        filter[1]=true;
                        filter[2]=false;
                      });
                    },),
                    CountsContainer(text:"History",counts:counts[2].toString(),icon:Icons.av_timer,active: (filter.contains(false) && filter[2])?true:false,ontap: (){
                      setState(() {
                        filter[0]=false;
                        filter[1]=false;
                        filter[2]=true;
                      });
                    },),
                  ],
                ),
              ),
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.center,
          child: (){
            if(loading){
             return SpinKitCircle(color: grey,);
            }else if(_data==null){
              return Center(
                child: Text("No services yet"),
              );
            }else{
              if(_data.isEmpty){
                return Center(
                  child: Text("No services yet"),
                );
              }
              return Requests(_data,_position,filter);
            }
          }()
        )
      ),
    );
  }
  _getcurrentlocation() async{
    _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(_position==null){
      _position=await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    }
    setState(() {
      _position=_position;
    });
    _getData();

  }

  _getData() async{
     Firestore.instance.collection('service').where('mechanicid',isEqualTo: Home.userdata.documentID).orderBy('datetime',descending: true).getDocuments().then((value){
       if(value.documents.isNotEmpty){
         setState(() {
           loading=false;
           _data=value.documents;
         });
         _countdata(value.documents);
       }else{
         setState(() {
           loading=false;
         });
       }
     });
     _refreshdata();
  }

  _refreshdata() async{
    _subscription = Firestore.instance.collection('service').where('mechanicid',isEqualTo: Home.userdata.documentID).orderBy('datetime',descending: true).snapshots().listen((event) {
       setState(() {
         _data=event.documents;
       });
       _countdata(event.documents);
     });
  }

   _countdata(List<DocumentSnapshot> data) async{
     counts=[0,0,0];
     for(int index=0;index<data.length;index++){
       if(data[index]['status']=="accepted" ||
           data[index]['status']=="picked up" ||
           data[index]['status']=="repaired" || data[index]['status']=="out for pickup"){
         counts[1]++;
       }
       else if(data[index]['status'].contains('cancelled') || data[index]['status']=="success"){
         counts[2]++;
       }else if(data[index]['status']=="pending"){
         counts[0]++;
       }
       setState(() {
         counts=counts;
       });
     }
   }


@override
  void dispose() {
    _subscription.cancel();
     // TODO: implement dispose
    super.dispose();
  }
}
class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon,this.onclick});
  String title;
  IconData icon;
  VoidCallback onclick;
}

class CountsContainer extends StatefulWidget {
  String text;
  String counts;
  IconData icon;
  VoidCallback ontap;
  bool active;
  CountsContainer({this.text,this.counts,this.icon,this.ontap,this.active});
  @override
  _CountsContainerState createState() => _CountsContainerState();
}

class _CountsContainerState extends State<CountsContainer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.ontap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.active?blue:textc.withOpacity(0.3)
          ),
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.only(left:6,right: 6),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(widget.icon,color: widget.active?background:blue,),
                  SizedBox(width: 5,),
                  Text(widget.text,style: GoogleFonts.lato(color: widget.active?background:grey),),
                ],
              ),
              Text(widget.counts,style: GoogleFonts.lato(color: widget.active?background:voilet),)
            ],
          ),
        ),
      ),
    );
  }




}
