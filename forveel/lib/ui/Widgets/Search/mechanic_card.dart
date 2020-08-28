import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/ui/ForveelTile.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/mechanic_page_uid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class MechanicCard extends StatefulWidget {
DocumentSnapshot data;
MechanicCard(this.data);
  @override
  _MechanicCardState createState() => _MechanicCardState();
}

class _MechanicCardState extends State<MechanicCard> {
  @override
  Widget build(BuildContext context) {
    return  ForveelTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      width: 70,
                height: 70,
                fit: BoxFit.cover,
                imageUrl: widget.data['photo'],
                placeholder: (context, url) => SpinKitCircle(color: grey,),
                errorWidget: (context, url, error) => Icon(Icons.error),
                )
         ),
            middle:  <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2,
                padding: EdgeInsets.all(2),
                child: Text(widget.data['shopname'].toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: GoogleFonts.lato(color: voilet,fontSize: 16),
                ),
              ),
                Row(
                  children: <Widget>[
                    (widget.data['vehicle_type'].contains("tw"))?Container( margin:EdgeInsets.only(right: 5),child: Icon(FontAwesomeIcons.motorcycle,color: green,)):Container(),
                    (widget.data['vehicle_type'].contains("fw"))?Container( margin:EdgeInsets.only(right: 5),child: Icon(FontAwesomeIcons.car,color: green,)):Container(),
                    Text(widget.data['name'],style: GoogleFonts.lato(fontWeight: FontWeight.w300,color: grey),),
                  ],
                ),

              Container(
                width: MediaQuery.of(context).size.width/2,
                padding: EdgeInsets.all(2),
                child: Text(widget.data['types'].toString().replaceAll("[", "").replaceAll("]", ""),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: GoogleFonts.lato(color: grey),
                ),
              ),
              Row(
                    children: List.generate(int.parse(widget.data['rating']['value'].toString().split(".")[0]).floor(), (index) {
                      return
                        Icon(Icons.star,color: Colors.yellow,);

                    })
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  padding: EdgeInsets.all(2),
                  child: Text(widget.data['address'],
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 2,
                    style: GoogleFonts.lato(
                      fontSize: 12,color: grey),
                  ),
                ),
              ],


ontap: (){
       Navigator.push(context, PageTransition(
         child: MechanicPageUID(widget.data.documentID,widget.data),
         type: PageTransitionType.fade,
         duration: Duration(milliseconds: 5)
       ));
},
          );


  }
}
