import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:http/http.dart';
import 'package:qrscan/qrscan.dart';
import 'package:toast/toast.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

class CompleteService extends StatefulWidget {
  DocumentSnapshot data;
  CompleteService(this.data);
  @override
  _CompleteServiceState createState() => _CompleteServiceState();
}

class _CompleteServiceState extends State<CompleteService> {
  bool scansuccess;
  String cost;
  String cameraScanResult;
  TextEditingController _controller=new TextEditingController();

  @override
  void initState() {
    scansuccess=false;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: grey,
        title: Text("Complete service",style: TextStyle(color: background),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage("assets/images/bgimage.jpg"),
            fit: BoxFit.fill,
          ),
        ),        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8,sigmaY: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              scansuccess?Text("Successfully scanned QR code!",style: TextStyle(color: green),):Container(),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.qrcode,color: background,),
                    SizedBox(width: 10,),
                    Text("Scan Customer's QR code",style: TextStyle(color: background),),
                  ],

                ),
                color: voilet,
                onPressed: ()async{
                  cameraScanResult = await scan();
                  setState(() {
                    scansuccess=true;
                  });
                },
                elevation: 10,
              ),
              TextField(
                style: TextStyle(
                    color: grey
                ),
                autofocus: true,
                keyboardType: TextInputType.number,
                controller: _controller,
                decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.moneyBill,color: green),
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Cost of service",
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7))
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  color: pink,
                  child: Text("submit",style: TextStyle(color: background),),
                  onPressed: (){
                    if(_controller.text==""){
                      Vibration.vibrate(duration: 200,amplitude: 50,);
                      Toast.show("please enter total cost..", context,gravity: Toast.CENTER);
                    }
                    else if(!scansuccess|| cameraScanResult==null) {
                      Toast.show(
                          "Please scan qr code of the customer!", context,
                          gravity: Toast.CENTER);
                    }
                    else{
                      cost=_controller.text;
                      if(widget.data['userid']==cameraScanResult){
                        Firestore.instance.collection('service').document(widget.data.documentID).updateData({
                          "status":"success",
                          "charges":cost.toString(),
                          "datetime":DateTime.now().millisecondsSinceEpoch.toString()
                        }).then(
                            (value){
                              Navigator.pop(context,{"status":"success"});
                              Toast.show(
                                  "Successfully completed!", context,
                                  gravity: Toast.CENTER);
                            }
                        );
                      }
                      else{
                        Toast.show(
                            "Wrong QR code!", context,
                            gravity: Toast.CENTER);
                        Vibration.vibrate(duration: 100);
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
