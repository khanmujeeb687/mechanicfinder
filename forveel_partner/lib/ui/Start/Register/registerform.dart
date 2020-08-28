import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/Internet/check_network_connection.dart';
import 'package:forveel_partner/Resources/Internet/internetpopup.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/waiting.dart';
import 'package:forveel_partner/ui/Start/Puncture/PunctureRegister.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../loader_dialog.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String phone;
  String passwordone;
  String passwordtwo;
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
          SizedBox(height: 20),
          Text("Register",
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
                  return "Please enter phone number";
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
                else if(value!=passwordtwo){
                  passwordone=value;
                  return "Both the passwords does not match";
                }
                else{
                  passwordone=value;
                  return null;
                }
              },
              onChanged: (v){
                passwordone=v;
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
                labelText: "Re-Enter password",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(10),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please Re-Enter your password";
                }
                else if(passwordone!=value){
                  passwordtwo=value;
                  return "Both the passwords does not match";
                }
                else{
                  passwordtwo=value;
                  return null;
                }
              },
              onChanged: (value){
                passwordtwo=value;
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
              child: Text('Submit',style: TextStyle(
                  color: background
              ),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.bottomCenter,
            child: OutlineButton(
              borderSide: BorderSide(color: voilet),
              child: Text("Register only for puncture shop",style: GoogleFonts.lato(color: voilet),),
              onPressed: (){
                Navigator.push(context, PageTransition(
                    child: PunctureRegister(),
                    duration: Duration(milliseconds: 50),
                    type: PageTransitionType.fade
                ));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.bottomCenter,
            child: OutlineButton(
              borderSide: BorderSide(color: green),
              child: Text("Already registered? Login",style: GoogleFonts.lato(color: green),),
              onPressed: (){
                Navigator.pop(context);
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
    Firestore.instance.collection('mechanic').add({
      "name":"null",
      "shopname":"",
      "address":"",
      "adhar":"",
      "city":"",
      "desc":"",
      "dob":"",
      "email":"",
      "exp":"",
      "lat":"",
      "long":"",
      "online":true,
      "phone":phone,
      "photo":"",
      "pwd":passwordtwo,
      "rating":{},
      "types":[],
      "vehicle_type":[],
      "verified":false,
      "datetime":DateTime.now().millisecondsSinceEpoch.toString(),
      "onlypuncture":false,
      "twowheelpuncture":false,
      "threewheelpuncture":false,
      "fourwheelpuncture":false,
      "morewheelpuncture":false,
      "Two wheeler":[],
      "Four wheeler":[],
      "services":[],
      "pickup":false
    }).then((value) async{
      value.get().then((value) async{
       await FirebaseAuth.instance.signInAnonymously();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userlogin',value.documentID);
        Navigator.push(context, PageTransition(
            child: waiting(value),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 50)
        ));
      });
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


