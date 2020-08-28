import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forveel/ui/Pages/Diagnose_page.dart';

import '../Mycolors.dart';
class DiagnoseResult extends StatefulWidget {
 List<int> answers;
  DiagnoseResult(this.answers);
  @override
  _DiagnoseResultState createState() => _DiagnoseResultState();
}

class _DiagnoseResultState extends State<DiagnoseResult> {

  String _result;

  @override
  void initState() {
    _result=calculateresult(widget.answers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container
        (
        padding: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage("assets/images/bgimage.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 8,sigmaX: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Card(
                    color: background.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
color: background.withOpacity(0.4)
                    ),
                    padding: EdgeInsets.all(30),
                    child: Text(_result,style: TextStyle(
                      fontSize: 18,
                      color: background,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

String calculateresult(List<int> answers)
{

  String result="";

  if(answers[0]==1)
    {
      result=result+"\nLate Starting of engine may be because of low battery or malfunctioning of the sensor.";
    }
  if(answers[1]==1){
    result=result+"\n Mobil is leaking because of engine sealkit leakage.";
  }
    if(answers[2]==1){
    result=result+"\n White smoke is due to the malfunctioning of nozzle.";
  }
   if(answers[3]==1){
    result=result+"\n Engine heating up or chocking of EGR.";
  }
   if(answers[4]==1){
    result=result+"\n Shocker problem or Alignment Out.";
  }
   if(answers[5]==1){
    result=result+"\n Engine Heating up due to the lack of Engine oil, Radiator fan may not working properly,\n"
        "Or lack of water in the radiator.";
  }
   if(answers[6]==1){
    result=result+"\n Pickup is low because of EGR chocking or clutch malfunctioning or clutch pressure plate malfunctioning.";
  }
   if(answers[7]==1){
    result=result+"\n Malfunctioning of the gearbox.";
  }
   if(answers[8]==1){
    result=result+"\n Tyres wearing out due to shocker problem or alignmentout.";
  }
   return result;

}