import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Start/Login/Login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class PunctureHome extends StatefulWidget {
  DocumentSnapshot userdata;
  PunctureHome(this.userdata);
  @override
  _PunctureHomeState createState() => _PunctureHomeState();
}

class _PunctureHomeState extends State<PunctureHome> {
  List<CustomPopupMenu> choices;
  @override
  void initState() {
    choices = <CustomPopupMenu>[
      CustomPopupMenu(title: 'Logout', icon: FontAwesomeIcons.signOutAlt,onclick:() async{
        if(await _rusure()){
          return;
        }
        SharedPreferences prefs=await SharedPreferences.getInstance();
        prefs.setString('userlogin', "0");
        await FirebaseAuth.instance.signOut();
        Navigator.push(context, PageTransition(
            child: Login(),
            duration: Duration(milliseconds: 10),
            type: PageTransitionType.fade
        ));
      }),
    ];
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
        backgroundColor: background,
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<CustomPopupMenu>(
              icon: Icon(Icons.more_vert,color: grey,),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              elevation: 10,
              onSelected: (choice){
                choice.onclick();
              },
              itemBuilder: (BuildContext context) {
                return choices.map((CustomPopupMenu choice) {
                  return PopupMenuItem<CustomPopupMenu>(
                    value: choice,
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(choice.icon,color: grey,),
                        Text(choice.title,style: GoogleFonts.lato(color:grey),)
                      ],
                    ),
                  );
                }).toList();
              },
            )
          ],
          backgroundColor: background,
          centerTitle: true,
          title: Text("Home",style: GoogleFonts.lato(color: grey),textAlign: TextAlign.center,),
        ),
        body: Container(
          alignment: Alignment.center,
        ),
      ),
    );
  }
  Future<bool> _rusure() async{
    bool sure=true;
    sure=await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return WillPopScope(
            onWillPop: (){
              Navigator.pop(context,true);
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              title: Text("Are you sure?",style: GoogleFonts.lato(color: grey),),
              actions: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: voilet,
                  child: Text("Logout",style: GoogleFonts.lato(color: background),),
                  onPressed: (){
                    Navigator.pop(context,false);
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: voilet,
                  child: Text("cancel",style: GoogleFonts.lato(color: background),),
                  onPressed: (){
                    Navigator.pop(context,true);
                  },)
              ],
            ),
          );
        }

    );
    return sure;
  }
}
