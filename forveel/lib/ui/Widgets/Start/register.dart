import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/Resources/ui/poweredby.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../loader_dialog.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  Color black=Colors.black;
  String myvarificationid;
  static var firebaseAuth = FirebaseAuth.instance;
  String phone;
  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerotp = new TextEditingController();
  double pinpilltop;
  double pinpilltopotp;
  double pinpillloading;
  String status;
  @override
  void initState() {
    status="";
    pinpilltop=1;
    pinpilltopotp=-500;
    pinpillloading=-500;
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
          body:Container(
            decoration: BoxDecoration(
                color: background
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 6,sigmaX: 6),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[

                           Container(
                            margin: EdgeInsets.only(top: 50),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height/2,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  height: MediaQuery.of(context).size.width/2,
                                  child: ClipOval(
                                      child: Image.asset("assets/images/forveel_logo_png.png",fit: BoxFit.cover,),
                                  ),
                                ),
                                Text("forveel",style: GoogleFonts.lato(color: grey,fontSize:40),),
                              ],
                            ),
                          ),

                        ],
                      ),

                    ),


                    //getting login
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      bottom: pinpilltop,
                      child: GestureDetector(
                        child: Container(
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width,
                          child:   ListView(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Text("Login",textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  color: textc,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30
                                ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height/2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      margin: EdgeInsets.all(20),
                                      elevation: 10,
                                      color: Colors.white,
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: TextField(
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          style: GoogleFonts.lato(color: grey),
                                          decoration: InputDecoration(
                                            counterText: "",
                                              hintText: "Phone",
                                              hintStyle: GoogleFonts.lato(
                                                  color: black
                                              ),
                                              border: InputBorder.none,
                                          ),
                                          controller: _controller,
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      color: voilet,
                                      child: Text("Send OTP", style: GoogleFonts.lato(color: background),),
                                      onPressed: () {
                                        if (_controller.text == "") return;
                                        startPhoneAuth(_controller.text);
                                      },

                                    ),
                                    Poweredby()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
             },
                      ),
                    ),


                    //getting otp
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      bottom: pinpilltopotp,

                      child: GestureDetector(
                        child: Container(
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width,
                          child:   ListView(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                alignment: Alignment.center,
                                child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Change number",style: GoogleFonts.lato(color: grey),),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        pinpilltopotp=-500;
                                        pinpilltop=1;
                                        pinpillloading=-500;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height/2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      margin: EdgeInsets.all(20),
                                      elevation: 10,
                                      color: Colors.white,
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: TextField(
                                          keyboardType: TextInputType.phone,
                                          maxLength: 6,
                                          style: GoogleFonts.lato(color: grey),
                                          decoration: InputDecoration(
                                            counterText: "",
                                              hintText: "OTP",
                                              hintStyle: TextStyle(
                                                  color: black
                                              ),
                                              border: InputBorder.none
                                          ),
                                          controller: _controllerotp,
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      color: voilet,
                                      child: Text("submit", style:GoogleFonts.lato(color: background),),
                                      onPressed: () {
                                        if(_controllerotp.text.length<6){
                                          Toast.show("Please enter 6 digit code", context);
                                          return;
                                        }
                                        if(_controllerotp.text.isEmpty) return;
                                        _signInWithPhoneNumber(_controllerotp.text);
                                      },

                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){

                        },
                      ),
                    ),


                //loading
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      bottom: pinpillloading,

                      child: GestureDetector(
                        child: Container(
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width,
                          child:   Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(status,style: TextStyle(fontSize:25,color: textc)),
                              SpinKitWave(color: textc)
                            ],
                          )
                        ),
                        onTap: (){

                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      )
    );
  }

  startPhoneAuth(phone) async{
    this.phone=phone;
    FocusScope.of(context).requestFocus(FocusNode());
    if(await IsConnectedtoInternet()){
    ShowInternetDialog(context);
    return;
    }
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    setState(() {
      pinpilltop=-500;
      pinpillloading=1;
      status="Sending OTP";
    });
  }


  codeSent(String verificationId, [int forceResendingToken]) async {
    myvarificationid=verificationId;
    phone=_controller.text;
    Toast.show("code sent",context);
    setState(() {
      pinpillloading=-500;
      pinpilltopotp=1;
      pinpillloading=-500;
    });
  }

  codeAutoRetrievalTimeout(String verificationId) {
    Toast.show("code auto retrival timeout",context);
  }
  verificationFailed (AuthException authException) {
    setState(() {
      pinpilltopotp=-500;
      pinpilltop=1;
      pinpillloading=-500;
    });
    if (authException.message.contains('not authorized')){
      setState(() {
        pinpilltopotp=-500;
        pinpilltop=1;
        pinpillloading=-500;
      });
      Toast.show('Something has gone wrong, please try later',context);}
    else if (authException.message.contains('Network')){
      setState(() {
        pinpilltopotp=-500;
        pinpilltop=1;
        pinpillloading=-500;
      });
      Toast.show('Please check your internet connection and try again',context);}
    else{
      setState(() {
        pinpilltopotp=-500;
        pinpilltop=1;
        pinpillloading=-500;
      });
      Toast.show('Something has gone wrong, please try later',context);}
  }

 _OnAuthSuccess() async{
LoaderDialog(context, false);
    _checkuserindatabase();
    }


  void verificationCompleted(AuthCredential phoneAuthCredential) async{

    firebaseAuth.signInWithCredential(phoneAuthCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        Toast.show('Authentication successful',context);
        _OnAuthSuccess();
      } else {
        setState(() {
          pinpilltopotp=-500;
          pinpilltop=1;
          pinpillloading=-500;
        });
        Toast.show('Invalid code/invalid authentication',context);
      }
    }).catchError((error) {
      setState(() {
        pinpilltopotp=-500;
        pinpilltop=1;
        pinpillloading=-500;
      });
      Toast.show('Something has gone wrong, please try later',context);
    });
  }



  void _signInWithPhoneNumber(String smsCode) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    setState(() {
      pinpilltopotp=-500;
      pinpilltop=-500;
      pinpillloading=1;
      status="Verifying OTP";
    });
    if(myvarificationid==""){ Toast.show("wrong pin", context); return;}
    var _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: myvarificationid, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      setState(() {
        setState(() {
          pinpilltopotp=-500;
          pinpilltop=1;
          pinpillloading=-500;
        });
        Toast.show("Something has gone wrong, please again",context);

      });

    }).then((user) async {
      if(user==null){
        setState(() {
          status="Wrong Otp";
          Toast.show("wrong OTP", context);
          pinpilltopotp=-500;
          pinpilltop=1;
          pinpillloading=-500;
        });
        return;
      }
      if(user.user!=null){
        setState(() {
          pinpilltopotp=-500;
          pinpilltop=-500;
          pinpillloading=1;
          status="Loging in";
        });
        _OnAuthSuccess();
      }
      else{
        setState(() {
          status="Wrong Otp";
          Toast.show("wrong OTP", context);
          pinpilltopotp=-500;
          pinpilltop=1;
          pinpillloading=-500;
        });
      }

    });
  }



  _checkuserindatabase()async{
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    final QuerySnapshot result=await

    Firestore.instance.collection("user").where("phone",isEqualTo: this.phone).getDocuments();

    final List<DocumentSnapshot> documents= result.documents;

    if(documents.length==0)
    {
      Firestore.instance.collection("user").add({
        'phone':phone,
        "registerdatetime":DateTime.now().millisecondsSinceEpoch.toString(),
        "datetime":DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value)async{
        SharedPreferences prefs=await SharedPreferences.getInstance();
        prefs.setString('userlogin', value.documentID.toString());
        value.get().then((value){
        _startActivity(value);
        });

      });
    }
    else{
      Firestore.instance.collection('user').document(documents[0].documentID).updateData({
        "datetime":DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value)async{
        SharedPreferences prefs=await SharedPreferences.getInstance();
        prefs.setString('userlogin', documents[0].documentID.toString());
        _startActivity(documents[0]);
      });
    }

  }

  Future<void> _startActivity(value) async {
    try {
      String result = await platform.invokeMethod('StartSecondActivity');
      if(result=="success")
      {
        Navigator.pop(context);
        Navigator.push(context, PageTransition(
            child: Home(value),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 10)
        ));
      }
      else{
        Toast.show("Please allow location permission", context);
        SystemNavigator.pop();
      }
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
      Toast.show("Please allow location permission", context);
      SystemNavigator.pop();
    }
  }

}



