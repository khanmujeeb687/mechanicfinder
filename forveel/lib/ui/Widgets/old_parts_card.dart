import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Mycolors.dart';

class OldPartCard extends StatefulWidget {
  String imgurl;
  String off;
  String name;
  OldPartCard(this.imgurl,this.name,this.off);
  @override
  _OldPartCardState createState() => _OldPartCardState();
}

class _OldPartCardState extends State<OldPartCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Image.asset(widget.imgurl,height: (MediaQuery.of(context).size.width/2)-20,
            width: (MediaQuery.of(context).size.width/2)-20,),
          SizedBox(height: 10,),
          Text(widget.name,style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
            color: textc
          ),),
          SizedBox(height: 5,),

          SizedBox(height: 4,),
          Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.solidBell,size:20,color: myyellow,),
              SizedBox(width: 6,),
              Text("${widget.off}% Off",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.green
              ),
              ),
            ],
          ),
          SizedBox(height: 10,)

        ],
      ),
    );
  }
}
