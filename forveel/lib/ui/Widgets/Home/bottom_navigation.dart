//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:forveel/ui/Pages/Diagnose_page.dart';
//import 'package:forveel/ui/Pages/history_page.dart';
//import 'package:forveel/ui/Pages/home.dart';
//import 'package:forveel/ui/Pages/shopping_page.dart';
//import 'package:http/http.dart';
//import 'package:page_transition/page_transition.dart';
//
//import '../../Mycolors.dart';
//
//class BottomNavigation extends StatefulWidget {
//   GlobalKey<ScaffoldState> sccafold;
//BottomNavigation(this._bottomsheetcontroller,this.sccafold);
//  @override
//  _BottomNavigationState createState() => _BottomNavigationState();
//}
//
//class _BottomNavigationState extends State<BottomNavigation> {
//Color iconcolor=lime;
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          IconButton(icon: Icon(FontAwesomeIcons.user,color: iconcolor),onPressed:(){
//            if(widget._bottomsheetcontroller.isOpened){
//              widget._bottomsheetcontroller.hide();
//              return;
//            }
//            widget.sccafold.currentState.openDrawer();
//          },),
//          IconButton(icon: Icon(FontAwesomeIcons.carCrash,color: iconcolor),onPressed:(){
//            if(widget._bottomsheetcontroller.isOpened){
//              widget._bottomsheetcontroller.hide();
//              return;
//            }
//            Navigator.push(context, PageTransition(
//                child: DiagnosePage(),
//                type: PageTransitionType.scale,
//                duration: Duration(milliseconds: 300),
//                alignment: Alignment.bottomLeft
//            ));
//          },),
//          IconButton(icon: Icon(Icons.list,color: iconcolor),onPressed:(){
//            if(widget._bottomsheetcontroller.isOpened){
//              widget._bottomsheetcontroller.hide();
//            }
//            else if(!widget._bottomsheetcontroller.isOpened)
//              {
//                widget._bottomsheetcontroller.show();
//              }
//          },iconSize: 40,),
//          IconButton(icon: Icon(FontAwesomeIcons.shoppingBag,color: iconcolor),onPressed:(){
//            if(widget._bottomsheetcontroller.isOpened){
//              widget._bottomsheetcontroller.hide();
//              return;
//            }
//            Navigator.push(context, PageTransition(
//                child: ShoppingPage(),
//                type: PageTransitionType.scale,
//                duration: Duration(milliseconds: 300),
//                alignment: Alignment.bottomRight
//            ));
//          },),
//          Stack(
//            children: <Widget>[
//              Home.notifications!=""?Positioned(
//                left: 2,
//                top: 2,
//                child: Container(
//                  width: 17,
//                  height: 17,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10),
//                    color: Colors.red,
//
//                  ),
//                  alignment: Alignment.center,
//                  child: Text(Home.notifications,style: TextStyle(color: Colors.white),),
//                ),
//              ):Container(),
//              IconButton(icon: Icon(FontAwesomeIcons.history,color: iconcolor),onPressed:(){
//                if(widget._bottomsheetcontroller.isOpened){
//                  widget._bottomsheetcontroller.hide();
//                  return;
//                }
//                Navigator.push(context, PageTransition(
//                    child: HistoryPage(),
//                    type: PageTransitionType.scale,
//                    duration: Duration(milliseconds: 300),
//                    alignment: Alignment.bottomRight
//                ));
//              },),
//            ],
//          ),
//
//        ],
//      ),
//    );
//  }
//
//}
