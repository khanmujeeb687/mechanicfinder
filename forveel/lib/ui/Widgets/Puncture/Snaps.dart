import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snaplist/size_providers.dart';
import 'package:snaplist/snaplist_view.dart';

import 'SnapCard.dart';

class Snaps extends StatefulWidget {
  List<DocumentSnapshot> data;
  Position position;
  Snaps(this.data,this.position);
  @override
  _SnapsState createState() => _SnapsState();
}

class _SnapsState extends State<Snaps> {


  double maxwidth;
  double maxheight;
  double left;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maxwidth=MediaQuery.of(context).size.width/1.5;
    maxheight=MediaQuery.of(context).size.height/2.2;
    left=MediaQuery.of(context).size.width-maxwidth;
    left=left/2;
    return SnapList(
      snipDuration: Duration(milliseconds: 100),
      padding: EdgeInsets.only(left:left,right: left),
      alignment: Alignment.center,
      axis: Axis.horizontal,
      snipCurve: Curves.linear,
      sizeProvider: (index, data){
        if(index==data.next){
          return Size(maxwidth+data.progress/8,maxheight+data.progress/2);
        }
        if(index==data.center){
          return Size((maxwidth+10)-data.progress/8,(maxheight+50)-data.progress/2);

        }
        return Size(maxwidth,maxheight);
      },
      separatorProvider: (index, data){
        return Size(20,20);
      },
      builder: (context, index, data) => Snapcard(index,data,widget.data[index],widget.position),
    count: widget.data.length,
    );
  }

}
