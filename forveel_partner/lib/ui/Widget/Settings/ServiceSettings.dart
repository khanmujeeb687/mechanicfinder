import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forveel_partner/Resources/themes/light_color.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/home.dart';
import 'package:forveel_partner/ui/loader_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';


class ServiceSettings extends StatefulWidget {
  @override
  _ServiceSettingsState createState() => _ServiceSettingsState();
}

class _ServiceSettingsState extends State<ServiceSettings> {
  DocumentSnapshot _user;
  bool x=false;
  @override
  void initState() {
    _user=Home.userdata;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: LightColor.black,
        centerTitle: true,
        title: Text("Service setting",style: GoogleFonts.lato(color: grey),),
      ),
      body: Container(
        color: background,
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            _addmore(),
            Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height/1.25,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: _user['services'].length,
                  itemBuilder: (context,index){
                    return Dismissible(
                      confirmDismiss: (a)async{
                        if(x) return Future.value(false);
                        x=true;
                        Timer(Duration(seconds: 2),(){
                          x=false;
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("Remove this item"),
                          action:SnackBarAction(
                            textColor: green,
                            label: "Yes",
                            onPressed: (){
                              _removeservicemap(index);
                            },
                          ) ,
                        ));
                        return Future.value(false);
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: EdgeInsets.only(right: 20),
                        color: Colors.redAccent,alignment: Alignment.centerRight,child: Text("Remove",style: GoogleFonts.lato(color: background),),),
                      key: UniqueKey(),
                      child: ListTile(
                        onLongPress: (){
                          _showedit(index);
                        },
                        title: Text(_user['services'][index]['name'],style: GoogleFonts.lato(color: grey,fontWeight: FontWeight.w600),),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Rs. ${_user['services'][index]['price']}",style: GoogleFonts.lato(color: grey,decoration: TextDecoration.lineThrough,fontWeight: FontWeight.w400,letterSpacing: 1),),
                            Text((){
                              return "Rs.${
                              double.parse(_user['services'][index]['price'])-((double.parse(_user['services'][index]['price'])*double.parse(_user['services'][index]['off']))/100)
                              }";
                            }(),
                            style: GoogleFonts.lato(color: green,fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        trailing: Text("${_user['services'][index]['off']}% OFF",style: GoogleFonts.lato(color: pink),),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


 Widget _addmore(){
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ()=>_addnewservice(false,null),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: textc.withOpacity(0.5)
          ),
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.add,color: background,),
              SizedBox(width: 15,),
              Text("Add more services",style: TextStyle(color: background),textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
  String name="";
  String price="0";
  String off="0";
  _addnewservice(bool update,int updateindex) async{
    var _formkey=GlobalKey<FormState>();
    Vibration.vibrate(duration: 100,amplitude: 10);
   await showDialog(context: context,
    builder: (context){
      return StatefulBuilder(
        builder: (context,setstate){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
            ),
            title: Text("Add new Service - \n Rs.${
                double.parse(price)-((double.parse(price)*double.parse(off))/100)
            }",style: GoogleFonts.lato(color:grey),textAlign: TextAlign.center,),
            content: Container(
                height: MediaQuery.of(context).size.width/1.25,
                width: MediaQuery.of(context).size.width/1.1,
                child:Form(
                  key: _formkey,
                  child: ListView(
                    children: <Widget>[

                      Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: new TextFormField(
                          style: TextStyle(
                              color: grey
                          ),
                          keyboardType: TextInputType.text,
                          initialValue: name,
                          decoration: new InputDecoration(
                            counterText: "",
                            labelText: "Service name",
                            border: new OutlineInputBorder(
                              gapPadding: 7,
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          // ignore: missing_return
                          validator: (value){
                            if(value.isEmpty)
                            {
                              return "Please enter a service name";
                            }
                            else{
                              name=value;
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: new TextFormField(
                          initialValue: price=="0"?"":price,
                          style: TextStyle(
                              color: grey
                          ),
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "Price in rupees",
                            border: new OutlineInputBorder(
                              gapPadding: 7,
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          // ignore: missing_return
                          validator: (value){
                            if(value.isEmpty)
                            {
                              return "Please enter service charge";
                            }
                            else{
                              price=value;
                              return null;
                            }
                          },
                          onChanged: (value){
                            if(value.isEmpty){
                              setstate(() {
                                price="0";
                              });
                              return;
                            }
                            setstate((){
                              price=value;
                            });
                          },
                        ),
                      ), Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: new TextFormField(
                          maxLength: 2,
                          style: TextStyle(
                              color: grey
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: off=="0"?"":off,
                          decoration: new InputDecoration(
                            counterText: "",
                            labelText: "% OFF",
                            border: new OutlineInputBorder(
                              gapPadding: 7,
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          // ignore: missing_return
                          validator: (value){
                            if(value.isEmpty)
                            {
                              return "Please enter percentage off";
                            }
                            else{
                              off=value;
                              return null;
                            }
                          },
                          onChanged: (value){
                            if(value.isEmpty){
                              setstate(() {
                                off="0";
                              });
                              return;
                            }
                            setstate(() {
                              off=value;
                            });
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
                            if(_formkey.currentState.validate()){
                              price=price.replaceAll("-", "");
                              off=off.replaceAll("-", "");
                              LoaderDialog(context, false);
                              List<dynamic> _temp = _user['services'];
                              if(update){
                                _temp[updateindex]['name']=name;
                                _temp[updateindex]['price']=double.parse(price).toStringAsFixed(2);
                                _temp[updateindex]['off']=double.parse(off).toStringAsFixed(2);

                              }else{
                                _temp.add({"name":name,"price":double.parse(price).toStringAsFixed(2),"off":double.parse(off).toStringAsFixed(2)});
                              }
                              Firestore.instance.collection("mechanic").document(_user.documentID).updateData({
                                "services":_temp
                              }).then((value){
                                Firestore.instance.collection("mechanic").document(Home.userdata.documentID).get().then((value){
                                  Home.userdata=value;
                                  setState(() {
                                    _user=value;
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              });
                            }
                          },
                          child: Text('Sumit',style: TextStyle(
                              color: background
                          ),),
                        ),
                      ),

                    ],
                  ),
                )
            ),
          );
        },
      );

    }
    );
   price="0";
   off="0";
   name="";
  }

  Future<bool> _removeservicemap(index) async{
    LoaderDialog(context, false);
    List<dynamic> temp=_user['services'];
    temp.removeAt(index);
    Firestore.instance.collection("mechanic").document(_user.documentID).updateData({
      "services":temp
    }).then((value){
      Firestore.instance.collection("mechanic").document(Home.userdata.documentID).get().then((value){
        Home.userdata=value;
        setState(() {
          _user=value;
        });
        Navigator.pop(context);
        return true;
      });
    });
  }

  void _showedit(index) {
    List<dynamic> temp=_user['services'];
    setState(() {
      name=temp[index]['name'];
      price=temp[index]['price'];
      off=temp[index]['off'];
    });
    _addnewservice(true,index);
  }
}
