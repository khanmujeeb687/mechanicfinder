import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/themes/light_color.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/home.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupSetting extends StatefulWidget {
  @override
  _PickupSettingState createState() => _PickupSettingState();
}

class _PickupSettingState extends State<PickupSetting> {
  bool pickup=Home.userdata['pickup'];
  int a=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pickup settings",style: GoogleFonts.lato(color: grey),),
        backgroundColor: LightColor.black,
      ),
      body: Container(
        color: LightColor.lightGrey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Enable Pickup",style: GoogleFonts.lato(color: grey),),
              subtitle: Text("You picks up the vehicle from the location also",style: GoogleFonts.lato(color: grey),),
              leading: Icon(FontAwesomeIcons.carCrash,color: LightColor.orange,),
              trailing: Switch(
                value: pickup,
                onChanged: (value) async{
                  if(a==1) return;
                  setState(() {
                    pickup=value;
                  });
                  a=1;
                 await Firestore.instance.collection("mechanic").document(Home.userdata.documentID).updateData({"pickup":value});
                 a=0;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
