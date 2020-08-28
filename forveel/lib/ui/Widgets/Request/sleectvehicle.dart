import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Widgets/Request/Change_bike.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

import 'change_car.dart';


class selectvehicle extends StatefulWidget {
  List<dynamic> vtypes;
  List<dynamic> two;
  List<dynamic> four;
  selectvehicle(this.vtypes,this.two,this.four);
  @override
  _selectvehicleState createState() => _selectvehicleState();
}

class _selectvehicleState extends State<selectvehicle> {
  String vehicle;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      title: Text("Select Vehicle type",style: GoogleFonts.lato(color:textc),textAlign: TextAlign.center,),
      content:Container(
        height: MediaQuery.of(context).size.height/3,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: background,
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              (widget.vtypes.contains('tw'))?RaisedButton(
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                color: voilet,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.motorcycle,color: background,),
                    Text("Two wheeler" ,style: TextStyle(color: background,fontWeight: FontWeight.w300,fontSize: 20),)
                  ],
                ),
                onPressed: ()async {
                  Map abc=await Navigator.push(context, PageTransition(
                      child:ChangeBike(widget.two),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 10)
                  ));
                  if(abc.containsKey("vehiclename"))
                  {
                    vehicle=abc["vehiclename"];
                    Navigator.pop(context,{
                      "vehicle":vehicle,
                      "vtype":"Two wheeler"
                    });
                  }
                },
              ):Flexible(
                child: Text("No two wheeler service at this member!",style: TextStyle(color: background),),
              ),
              (widget.vtypes.contains("fw"))?RaisedButton(
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                color: voilet,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.directions_car,color: background,),
                    Text("four wheeler" ,style: TextStyle(color: background,fontWeight: FontWeight.w300,fontSize: 20),)
                  ],
                ),
                onPressed: ()async {
                  Map abc=await Navigator.push(context, PageTransition(
                      child:ChangeCar(widget.four),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 10)
                  ));
                  if(abc.containsKey("vehiclename"))
                  {
                    vehicle=abc["vehiclename"];
                    Navigator.pop(context,{
                      "vehicle":vehicle,
                      "vtype":"Four wheeler"
                    });
                  }
                },
              ):Flexible(
                child: Text("No four wheeler service at this member!",style: TextStyle(color: background),),
              ),
            ],
          ),
        ),
    );
  }
}
