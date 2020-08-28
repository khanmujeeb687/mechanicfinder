import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:google_fonts/google_fonts.dart';


class GetPuncture extends StatefulWidget {
  @override
  _GetPunctureState createState() => _GetPunctureState();
}

class _GetPunctureState extends State<GetPuncture> {
  List<bool> _puncture = [false,false,false,false];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.pop(context,_puncture);
      },
      child: AlertDialog(
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        title: Text("Do you provide puncture service",style: GoogleFonts.lato(color: grey),),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: missing_return
            _selector("Two wheeler", (a){
              setState(() {
                _puncture[0]=a;
              });
            },_puncture[0]),
SizedBox(height: 7,),
             // ignore: missing_return
             _selector("Three wheeler", (a){
              setState(() {
                _puncture[1]=a;
              });
            },_puncture[1]),
            SizedBox(height: 7,),

             _selector("Four wheeler", (a){
              setState(() {
                _puncture[2]=a;
              });
            },_puncture[2]),
            SizedBox(height: 7,),

             _selector("More than four wheeler", (a){
              setState(() {
                _puncture[3]=a;
              });
            },_puncture[3]),



          ],
        ),
        actions: <Widget>[
          OutlineButton(
            child: Text("Go",style: GoogleFonts.lato(color: grey),),
            onPressed: (){
              Navigator.pop(context,_puncture);
            },
          )
        ],
      ),
    );
  }


  Widget _selector(String title,VoidCallback ontap(a),bool checkvalue){
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey,width: 1),
        color: background
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title,style: GoogleFonts.lato(color: voilet),),
          Checkbox(
            checkColor: green,
            onChanged: ontap,
            value: checkvalue,
          )
        ],
      ),
    );
  }
}


