import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Start/Register/registerform.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/bgimage.jpg"),
                          fit: BoxFit.cover
                      )
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5,sigmaX: 5),
                      child: Container(
                        height: MediaQuery.of(context).size.height/2,
                        width: MediaQuery.of(context).size.width,
                        color: background.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                  ),

                ),

              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height/1.5,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    elevation: 15,
                    color: background,
                    child: RegisterForm()
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
