import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forveel_partner/Resources/Internet/check_network_connection.dart';
import 'package:forveel_partner/Resources/Internet/internetpopup.dart';
import 'package:forveel_partner/Resources/ui/GetPuncture.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/waiting.dart';
import 'package:forveel_partner/ui/Start/completedetails/addlocation.dart';
import 'package:forveel_partner/ui/Start/completedetails/upload_video.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../loader_dialog.dart';

class PunctureRegister extends StatefulWidget {
  @override
  _PunctureRegisterState createState() => _PunctureRegisterState();
}

class _PunctureRegisterState extends State<PunctureRegister> {

  var _generalkey=GlobalKey<FormState>();

  String address;//address
  File adhar;//photo
  File photo;//photo
  String city;//address
  String lat;//address
  String long;//address
  String name;//general
  String passwordone;
  String passwordtwo;
  String phone;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text("Puncture Shop Registration",style: GoogleFonts.lato(color: grey),),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: _generalinfo(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        elevation: 15,
        onPressed: _submit
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _generalinfo(){
    return Form(
      key: _generalkey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30,)
          ,Text("Enter details",
            style: TextStyle(
                color: grey,
                letterSpacing: 2,
                fontSize: 30
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              keyboardType: TextInputType.text,
              initialValue: name!=null?name:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "name",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please enter your name";
                }
                else{
                  name=value;
                  return null;
                }
              },
              onChanged: (v){
                name=v;
              },
            ),
          ),SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              keyboardType: TextInputType.phone,
              initialValue: phone!=null?phone:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "Phone",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              maxLength: 10,
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
              onChanged: (v){
                phone=v;
              },
            ),
          ),SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              keyboardType: TextInputType.text,
              initialValue: name!=null?name:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "Password",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please enter your Password";
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
          ),SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              keyboardType: TextInputType.text,
              initialValue: passwordtwo!=null?passwordtwo:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "Re-Enter password",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please Re-enter your password";
                }if(value!=passwordone){
                  return "Both passwords does not matches";
                }
                else{
                  passwordtwo=value;
                  return null;
                }
              },
              onChanged: (v){
                passwordtwo=v;
              },
            ),
          ),

          SizedBox(height: 10),
          _Images()
,
          SizedBox(height: 10),
          _addressBTN()


        ],
      ),
    );
  }

  Widget _Images(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: grey),    color: background,

            ),
            padding: EdgeInsets.all(6),
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.width/2,
          child: InkWell(
            onTap: _selectImage,
            child: (){
              if(photo==null){
                return Center(child: Text("Select your Photo",style: GoogleFonts.lato(color: grey),),);
              }
              return Image.file(photo,fit: BoxFit.contain,);
            }(),
          )
        ),
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: grey),    color: background,

      ),
    padding: EdgeInsets.all(6),
    width: MediaQuery.of(context).size.width/2,
    height: MediaQuery.of(context).size.width/2,
    child: InkWell(
      onTap: _selectadhar,
      child: (){
        if(adhar==null){
          return Center(child: Text("Select your Adhar card",style: GoogleFonts.lato(color: grey),),);
        }
        return Image.file(adhar,fit: BoxFit.contain,);
      }(),
    )
    ),
      ],
    );
  }


  Widget _addressBTN(){
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width-20,
      decoration: BoxDecoration(
        border: Border.all(color: grey),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          address!=null?Flexible(child: Text(address,style: GoogleFonts.lato(color: grey))):Text("----"),
          OutlineButton(
            child:Text("Select address",style: GoogleFonts.lato(color: grey,fontSize: 15)),
            onPressed: ()async{
              Map addressdata=await Navigator.push(context, PageTransition(
                  child: AddLocation(),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 10)
              ));
              if(addressdata.isNotEmpty){
                setState(() {
                  address=addressdata["address"];
                  city=addressdata["city"];
                  lat=addressdata["lat"];
                  long=addressdata["long"];
                });

              }
            },
          )
        ],
      ),
    );
  }


  void _selectadhar() async{
    File image=await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 15);
    if(image!=null){
      setState(() {
        adhar=image;
      });
    }
  }
  void _selectImage() async{
    File image=await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 15);
    if(image!=null){
      setState(() {
        photo=image;
      });
    }
  }

  void _submit() async{
    if(_generalkey.currentState.validate()) {
      if (photo == null) {
        Toast.show("Please select your Image", context, gravity: Toast.CENTER);
        return;
      }
      if (adhar == null) {
        Toast.show(
            "Please select your Adhar card", context, gravity: Toast.CENTER);
        return;
      }
      if (address == null) {
        Toast.show(
            "Please select your Location", context, gravity: Toast.CENTER);
        return;
      }
      if (lat == null) {
        Toast.show(
            "Please select your Location", context, gravity: Toast.CENTER);
        return;
      }
      if (long == null) {
        Toast.show(
            "Please select your Location", context, gravity: Toast.CENTER);
        return;
      }
      if (city == null) {
        Toast.show(
            "Please select your Location", context, gravity: Toast.CENTER);
        return;
      }
      List<bool> _puncture = await showDialog(
          context: context, barrierDismissible: false, builder: (context) {
        return GetPuncture();
      });
      bool sure=false;
      sure=await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return WillPopScope(
              onWillPop: (){
                Navigator.pop(context,false);
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                title: Text("Sumit details?",style: GoogleFonts.lato(color: grey),),
                actions: <Widget>[
                  OutlineButton(
                    child: Text("Submit",style: GoogleFonts.lato(color: green),),
                    onPressed: (){
                      Navigator.pop(context,true);
                    },
                  ),
                  OutlineButton(
                    child: Text("Cancel",style: GoogleFonts.lato(color: voilet),),
                    onPressed: (){
                      Navigator.pop(context,false);
                    },
                  ),
                ],
              ),
            );
          }

      );
      if(!sure){
        return;
      }
      if(await IsConnectedtoInternet()){
        return ShowInternetDialog(context);
      }
      LoaderDialog(context, false);
    await FirebaseAuth.instance.signInAnonymously();
      Navigator.pop(context);
      Map waiter = await showDialog(
          context: context, barrierDismissible: false, builder: (context) {
        return UploadVideo(photo, adhar);
      });
      if (waiter.isNotEmpty) {

        String adharaddress=waiter["adhar"];
        String photoaddress=waiter["photo"];
        LoaderDialog(context, false);
        Firestore.instance.collection("mechanic").add({
          "name": name,
          "shopname": "",
          "address": address,
          "adhar": adharaddress,
          "city": city,
          "desc": "",
          "dob": "",
          "email": "",
          "exp": "",
          "lat": lat.toString(),
          "long": long.toString(),
          "online": true,
          "phone": phone,
          "photo": photoaddress,
          "pwd": passwordtwo,
          "rating": "0",
          "types": [],
          "vehicle_type": [],
          "verified": false,
          "datetime": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          "onlypuncture": true,
          "twowheelpuncture": _puncture[0],
          "threewheelpuncture": _puncture[1],
          "fourwheelpuncture": _puncture[2],
          "morewheelpuncture": _puncture[3],
        }).then((value){
          value.get().then((value)async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userlogin',value.documentID);
            Navigator.pop(context);
            Navigator.push(context, PageTransition(
                child: waiting(value),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 50)
            ));
          });
        });
      }else{
        Toast.show("Error occured!!", context,gravity: Toast.TOP);
      }
    }
  }
}
