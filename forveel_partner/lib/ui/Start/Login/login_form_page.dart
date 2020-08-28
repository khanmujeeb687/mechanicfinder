import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/Internet/check_network_connection.dart';
import 'package:forveel_partner/Resources/Internet/internetpopup.dart';
import 'package:forveel_partner/Resources/themes/light_color.dart';
import 'package:forveel_partner/ui/Pages/home.dart';
import 'package:forveel_partner/ui/Pages/puncturehome.dart';
import 'package:forveel_partner/ui/Pages/waiting.dart';
import 'package:forveel_partner/ui/Start/Register/register.dart';
import 'package:forveel_partner/ui/Start/forgot/Forgot.dart';
import 'package:forveel_partner/ui/loader_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../Mycolors.dart';

class LoginFormPage extends StatefulWidget {
  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  String phone;
  String password;
  bool showpass;
  var _formkey=GlobalKey<FormState>();
  @override
  void initState() {
    showpass=true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
          child: ListView(
            children: <Widget>[
              Text("Login",
              style: TextStyle(
                color: pink,
                letterSpacing: 2,
                fontSize: 30
              ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: new TextFormField(
                  style: TextStyle(
                      color: grey
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    counterText: "",
                    labelText: "phone",
                    border: new OutlineInputBorder(
                      gapPadding: 7,
                      borderRadius: new BorderRadius.circular(10),
                    ),
                  ),
                  // ignore: missing_return
                  validator: (value){
                    if(value.isEmpty)
                    {
                      return "Please enter your phone number";
                    }
                    else{
                      phone=value;
                      return null;
                    }
                  },
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: new TextFormField(
                  obscureText: showpass,
                  style: TextStyle(
                      color: grey
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(showpass?FontAwesomeIcons.eyeSlash:FontAwesomeIcons.eye),
                      onPressed: (){
                        setState(() {
                          showpass==false?showpass=true:showpass=false;
                        });
                      },
                ),
                    labelText: "Password",
                    border: new OutlineInputBorder(
                      gapPadding: 7,
                      borderRadius: new BorderRadius.circular(10),
                    ),
                  ),
                  // ignore: missing_return
                  validator: (value){
                    if(value.isEmpty)
                    {
                      return "Please enter your password";
                    }
                    else{
                      password=value;
                      return null;
                    }
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                child:  RaisedButton(
                  color: myyellow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  onPressed:(){
if(_formkey.currentState.validate())
  {
_startActivity();
  }
                  },
                  child: Text('Login',style: TextStyle(
                      color: background
                  ),),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.bottomCenter,
                child: OutlineButton(
                  borderSide: BorderSide(color: LightColor.orange),
                  child: Text("Do not have an account? Register",style: GoogleFonts.lato(color: LightColor.orange),),
                  onPressed: (){
                    Navigator.push(context, PageTransition(
                        child: Register(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50)
                    ));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                alignment: Alignment.bottomCenter,
                child: OutlineButton(
                  borderSide: BorderSide(color: LightColor.skyBlue),
                  child: Text("Forgot password?",style: GoogleFonts.lato(color: LightColor.skyBlue),),
                  onPressed: (){
                    Navigator.push(context, PageTransition(
                        child: Forgot(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50)
                    ));
                  },
                ),
              ),
            ],
          ),
    );
  }

  _loginuser() async{
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
LoaderDialog(context, false);
    Firestore.instance.collection('mechanic').where('phone',isEqualTo: phone).getDocuments().then((value) async{
      if(value.documents.isNotEmpty){
        if(value.documents[0]['pwd']!=password){
          Navigator.pop(context);
          Toast.show("Wrong Password", context,textColor: grey,backgroundColor: Colors.red,gravity: Toast.CENTER,duration: Toast.LENGTH_LONG);
        }
        else {
          Firestore.instance.collection('mechanic').document(value.documents[0].documentID).updateData({"datetime":DateTime.now().millisecondsSinceEpoch.toString()});
          await FirebaseAuth.instance.signInAnonymously();
          Navigator.pop(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userlogin',value.documents[0].documentID);
          if(value.documents[0]['verified']){
            if(value.documents[0]["onlypuncture"]){
              Navigator.push(context, PageTransition(
                  child: PunctureHome(value.documents[0]),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)
              ));
            }else{
              Navigator.push(context, PageTransition(
                  child: Home(value.documents[0]),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50)
              ));
            }

          }
          else{
            Navigator.push(context, PageTransition(
                child: waiting(value.documents[0]),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 50)
            ));
          }
        }
      }else{
        Navigator.pop(context);
        Toast.show("Account does not exits", context,textColor: grey,backgroundColor: Colors.red,gravity: Toast.CENTER,duration: Toast.LENGTH_LONG);
      }
    });

  }
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  Future<void> _startActivity() async {
    try {
      String result = await platform.invokeMethod('StartSecondActivity');
      if(result=="success")
      {
        _loginuser();
      }
      else{
        Toast.show("Please allow location permission", context);
      }
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
      Toast.show("Please allow location permission", context);
    }
  }
}


