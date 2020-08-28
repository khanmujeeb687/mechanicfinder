import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/Resources/themes/light_color.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Widgets/Search/mechanic_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DocumentSnapshot> _data;
  TextEditingController _controller;
  bool loading=false;
  @override
  Future<void> initState(){
    _data=null;
_controller=new TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: voilet,
        title: Text("Search",style: GoogleFonts.lato(
          color: background
        ),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LightColor.lightblack,
        child: loading?SpinKitCircle(color: background,):Icon(Icons.send),
        onPressed: _getdata,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: ListView(
        children: <Widget>[
          ClipRRect(
            child: Container(
              height:80,
              alignment: Alignment.bottomCenter,
              color: voilet,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: background,
                  fontSize: 17
                ),
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: "search shopname...",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: background
                  ),
                ),
              ),
            ),
          ),
          Container(
child:(_data==null)?Container(
                        color: background,
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.searchengin,size: 20,color: Colors.grey,),
                              SizedBox(width: 7,),
                              Text("Search a mechanic..",style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),
                        ),
                      ):Container(
                    height: MediaQuery.of(context).size.height/1.5,
                          color: background,
                          child:   ListView.builder(
                          itemCount: _data.length,
                            physics: ScrollPhysics(),
                          itemBuilder: (context,index){
                            return MechanicCard(_data[index]);
                          },
                            ),
                      )



          )


        ],
      ),
    );
  }


  void _getdata() async{
    if(loading) return;
    if(_controller.text.isEmpty) return;
    setState(() {
      loading=true;
    });
    await Firestore.instance.collection("mechanic").where('shopname',isEqualTo: _controller.text)
    .limit(10)
    .getDocuments().then((value) {
      if(value.documents.isNotEmpty){
        _data=value.documents;
      }else{
        Toast.show("No results", context,backgroundColor: Colors.black,textColor: background,gravity: Toast.TOP,backgroundRadius: 6);
      }
    });
    setState(() {
      _data=_data;
      loading=false;
    });
  }
}
