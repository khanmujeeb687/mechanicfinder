import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Start/Login/login_form_page.dart';
import 'package:forveel_partner/ui/Start/Register/register.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
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
                    child: LoginFormPage()
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
