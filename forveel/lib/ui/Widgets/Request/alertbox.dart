import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/ui/Pages/history_page.dart';
import 'package:forveel/ui/Pages/home.dart';
import 'package:forveel/ui/Widgets/Request/sleectvehicle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import '../../Mycolors.dart';
import '../../loader_dialog.dart';

class alertbox extends StatefulWidget {

  DocumentSnapshot mechanic;
  String address;
  alertbox(this.mechanic,this.address);
  @override
  _alertboxState createState() => _alertboxState();
}

class _alertboxState extends State<alertbox> {
  TextEditingController _controller=new TextEditingController();
  String vehicle="";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5.0,sigmaX: 5.0),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
            elevation: 10,
            backgroundColor: background,
            title: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              color: voilet,
              child: Text("select vehicle",style: GoogleFonts.lato(
                color: background
              ),),
              onPressed: ()async{
                FocusScope.of(context).requestFocus(FocusNode());
                Map abc=await  showDialog(context: context,builder: (context){
                  return selectvehicle(widget.mechanic['vehicle_type'],widget.mechanic['Two wheeler'],widget.mechanic['Four wheeler']);
                });
                if(abc.containsKey("vehicle")){
                  setState(() {
                    vehicle=abc["vehicle"]+"-"+abc['vtype'];
                  });
                }
              },
            ),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(vehicle,style: TextStyle(color: grey),),
                  SizedBox(height: 7,),
                  TextField(
                    style: GoogleFonts.lato(color: grey),
                    controller: _controller,
                    maxLines: 5,
                    maxLength: 500,
                    decoration: InputDecoration(
                        hintText: "Explain issue(optional).."
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    color: green,
                    child: Text("submit request",style: GoogleFonts.lato(color: background),),
                    onPressed: (){
                      if(vehicle.isEmpty){
                        Toast.show("Please select a vehicle!", context,gravity: Toast.TOP);
                      }
                      else{
                        _sendrequest(_controller.text,vehicle);
                      }
                    },
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
  void _sendrequest(text,vehicle) async{
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    LoaderDialog(context,false);
    Firestore.instance.collection('service').add({
      "mechanicid":widget.mechanic.documentID,
      "userid":Home.userdata.documentID,
      "issue":text,
      "lat":widget.mechanic['lat'],
      "long":widget.mechanic['long'],
      "uservehicle":vehicle,
      "status":"pending",
      "review":"",
      "charges":"",
      "rating":"",
      "isreviewed":false,
      "reason":"",
      "name":widget.mechanic['name'],
      "shopname":widget.mechanic['shopname'],
      "phone":Home.userdata['phone'].toString(),
      "address":widget.address,
      "datetime":DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value){
      if(!mounted) return;
      if(value==null){
        Toast.show("An error ocuured", context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        return;
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, PageTransition(
          child: HistoryPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 10)
      ));
    });

  }



  }
