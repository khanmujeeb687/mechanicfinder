import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Widgets/Home/Photoview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snaplist/size_providers.dart';
import 'package:url_launcher/url_launcher.dart';


class Snapcard extends StatefulWidget {
  int index;
  BuilderData data;
  DocumentSnapshot carddata;
  Position position;
  Snapcard(this.index,this.data,this.carddata,this.position);
  @override
  _SnapcardState createState() => _SnapcardState();
}

class _SnapcardState extends State<Snapcard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: ()async{
_puncturemandialog();
          },
          child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.purple[700],Colors.redAccent,Colors.pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    image: DecorationImage(
                      image:AdvancedNetworkImage(
                        widget.carddata['photo'],
                        useDiskCache: true,
                        cacheRule: CacheRule(maxAge: const Duration(days: 30)),
                      ),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3,sigmaY: 3),
                        child: Container(
                          decoration: BoxDecoration(
                              color: background.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(widget.carddata['name'],style:
                              GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                              ),
                              Text(widget.carddata['address'],style:
                              GoogleFonts.lato(
                                color: Colors.black54,
                                fontSize: 12,
                                letterSpacing: 2,
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              IconButton(
                                icon: Icon(Icons.directions,color: Colors.black,),
                                onPressed: (){
                                  _launchMapsUrl();
                                },
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                ),

                (widget.index!=widget.data.next && widget.data.progress>60)?Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(widget.data.progress/150)
                  ),
                ):Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _puncturemandialog(){
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40)
      ),
      backgroundColor: Colors.black,
      title: Text("Info.",textAlign: TextAlign.center,style: GoogleFonts.lato(color: Colors.white),),
      content: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width-30,
        child: ListView(
          children: <Widget>[
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: background,width: 2),
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/6),
                ),
                elevation: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      if(widget.carddata['photo']!=""){
                        Navigator.push(context, PageTransition(
                            child: Photoviewer(url:widget.carddata['photo']),
                            duration: Duration(milliseconds: 300),
                            type: PageTransitionType.scale,
                            alignment: Alignment.topCenter
                        ));
                      }
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/4),
                        child: CachedNetworkImage(
                          imageUrl: widget.carddata['photo'],
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.width/3,
                          width: MediaQuery.of(context).size.width/3,
                        )
                    ),
                  ),
                ),
              ),
            ),
            Text(widget.carddata['name'],style: GoogleFonts.lato(color: background),textAlign: TextAlign.center,),
            Divider(color: grey,),
            Text(widget.carddata['address'],style: GoogleFonts.lato(color: textc),textAlign: TextAlign.center,),
            Divider(color: grey,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                  color: voilet,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Text("Contact"),
                  onPressed: (){
_showcontact();
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.directions,color: grey,),
                      onPressed: (){
_launchMapsUrl();
                      },
                    ),
                    Text("Direction",style: GoogleFonts.lato(color:grey,letterSpacing: 2,fontSize: 10),)
                  ],
                )
              ],
            )
          ],
        ),
      ),
      );
    },
    );
  }



   _showcontact(){
  showDialog(context: context,
  builder: (context){{
  return AlertDialog(
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(40)
  ),
  title: Text("Contact forveel partner",textAlign: TextAlign.center,style: TextStyle(color: voilet,fontSize: 15,fontWeight: FontWeight.w400),),
  content: Container(
  child: Row(
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  Card(
  child: Container(
  child: IconButton(
  icon: Icon(Icons.call,color: background,),
  onPressed: ()async{
  String url = "tel:${widget.carddata['phone']}";
  if (await canLaunch(url)) {
  await launch(url);
  } else {
  throw 'Could not launch $url';
  }
  },
  ),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: Colors.blue.shade300,
  ),
  width: 50,
  height: 50,
  ),

  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(30),
  ),
  ),
  Card(
  child: Container(
  child: IconButton(
  icon: Icon(Icons.sms,color: background,),
  onPressed: ()async{
  String url = "sms:+91 ${widget.carddata['phone']}";
  if (await canLaunch(url)) {
  await launch(url);
  } else {
  throw 'Could not launch $url';
  }
  },
  ),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: grey,
  ),
  width: 50,
  height: 50,
  ),

  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(30),
  ),
  ),
  Card(
  child: Container(
  child: IconButton(
  icon: Icon(FontAwesomeIcons.whatsapp,color: background,),
  onPressed: () async{
  String url = "whatsapp://send?phone=+91 ${widget.carddata['phone']}";
  if (await canLaunch(url)) {
  await launch(url);
  } else {
  throw 'Could not launch $url';
  }
  },
  ),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: green,
  ),
  width: 50,
  height: 50,
  ),

  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(30),
  ),
  ),
  ],
  ),
  ),
  );
  }});
  }


  void _launchMapsUrl() async {
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    final url = 'https://www.google.com/maps/dir/?api=1&origin=${widget.position.latitude},${widget.position.longitude}&destination=${widget.carddata["lat"]},${widget.carddata["long"]}&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
