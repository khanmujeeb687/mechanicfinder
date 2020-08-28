import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/Resources/themes/light_color.dart';
import 'package:forveel/Resources/ui/MechanicPageVidgets.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Widgets/Home/Photoview.dart';

import 'package:forveel/ui/Widgets/Request/alertbox.dart';
import 'package:geocoder/geocoder.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import 'package:url_launcher/url_launcher.dart';


class MechanicPageUID extends StatefulWidget {

  String id;
  DocumentSnapshot data;
MechanicPageUID(this.id,this.data);
  @override
  _MechanicPageUIDState createState() => _MechanicPageUIDState();
}

class _MechanicPageUIDState extends State<MechanicPageUID> {
Position _position;
  DocumentSnapshot _mechanic;
  bool load;
  String distance="";
  String _address="";
  StreamSubscription<DocumentSnapshot> subscription;

  @override
  void initState() {
    if(widget.data==null){
      load=false;
      _Loadmechanic();
    }else{
      _mechanic=widget.data;
      load=true;
      getcurrentlocation();
    }
_refreshavalability();
super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body:NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: background,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title:  Text("Mechanic",
          style: GoogleFonts.lato(
          color: LightColor.darkgrey,
          fontSize: 16.0,
          )),
                  background: CachedNetworkImage(
                    imageUrl: _mechanic['photo'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: !load?Center(
          child: SpinKitThreeBounce(
            color: grey,
          ),
        ):Container(
          decoration: BoxDecoration(
            color: LightColor.black
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 8,sigmaX: 8),
              child: ListView(
                children: <Widget>[
                  Center(child: VtypesShow(_mechanic['vehicle_type'],_mechanic['Two wheeler'],_mechanic['Four wheeler'])),
                  SizedBox(height: 15,),
                  Skills(_mechanic['types']),
                  SizedBox(height: 15,),
                  ListTile(
                    leading: Icon(_mechanic['pickup']?FontAwesomeIcons.check:Icons.error,color: LightColor.orange,),
                    title: Text(_mechanic['pickup']?"Provides pickup from your location":"Does not picks ups your vehicle from location",style: GoogleFonts.lato(
                        color: background
                    ),),
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.airline_seat_recline_extra,color: LightColor.orange,),
                    title: Text("Services",style: GoogleFonts.lato(color: background),),
                    children:List.generate(_mechanic['services'].length, (index){
                      return ListTile(
                        onLongPress: (){
                        },
                        title: Text(_mechanic['services'][index]['name'],style: GoogleFonts.lato(color: grey,fontWeight: FontWeight.w600),),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Rs. ${_mechanic['services'][index]['price']}",style: GoogleFonts.lato(color: grey,decoration: TextDecoration.lineThrough,fontWeight: FontWeight.w400,letterSpacing: 1),),
                            Text((){
                              return "Rs.${
                                  double.parse(_mechanic['services'][index]['price'])-((double.parse(_mechanic['services'][index]['price'])*double.parse(_mechanic['services'][index]['off']))/100)
                              }";
                            }(),
                              style: GoogleFonts.lato(color: green,fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        trailing: Text("${_mechanic['services'][index]['off']}% OFF",style: GoogleFonts.lato(color: pink),),
                      );
                    }),
                  ),
                  Divider(height: 1,),
                  SizedBox(height: 15,),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.user,color: LightColor.orange,),
                    title: Text("${_mechanic['name']} ",
                      style: GoogleFonts.lato(
                          color: background
                      ),),
                    trailing:  Column(
                      children: <Widget>[
                        (!_mechanic['online'])?Icon(FontAwesomeIcons.solidCircle,color: Colors.red,):Icon(FontAwesomeIcons.solidCircle,color: green,),
                        Text( (_mechanic['online'])?"Available":"Unavailable",style:GoogleFonts.lato(
                            color: background
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.home,color: LightColor.orange,),
                    title: Text("${_mechanic['shopname']}",style: GoogleFonts.lato(
                        color: background
                    ),),
                  ),
                  SizedBox(height: 15,),
                  ListTile(
                    leading: Icon(Icons.location_on,color: LightColor.orange,),
                    title: Text("${_mechanic['address']}",style: GoogleFonts.lato(
                        color: background,
                        fontSize: 14
                    ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text("Distance: ${distance} Km's",style: GoogleFonts.lato(
                        color: background
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: Text("${_mechanic['address']}",style: GoogleFonts.lato(
                            color: background,
                          ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.directions,color: pink),color: pink,
                              onPressed:_launchMapsUrl,
                            ),
                            Text("Get Directions",style: GoogleFonts.lato(
                                color: background
                            ),),
                          ],
                        )
                      ],
                    ),
                  ),   Container(
                    margin: EdgeInsets.all(20),
                    child: Text("Experiance: ${_mechanic['exp']} years",
                      style: GoogleFonts.lato(
                          color: background
                      ),
                    ),
                  ),   Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: List.generate(int.parse(_mechanic['rating']['value'].toString().split(".")[0]).floor(), (index){
                        return Icon(FontAwesomeIcons.solidStar,color: Colors.yellow,);
                      }),
                    ),
                  ),
                  SizedBox(height: 10,),
                  ListTile(
                    leading: Icon(Icons.wrap_text,color: LightColor.orange,),
                    title: Text(
                      "${_mechanic['desc']}"
                      ,
                      style: GoogleFonts.lato(
                          color: background
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(20),
                    child: (_mechanic['online'])?RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      color: green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.phone,color: background,),
                          SizedBox(width: 10,),
                          Text("Request a call",style: GoogleFonts.lato(color: background),)
                        ],
                      ),
                      onPressed: _showissuedialog,
                    ):Text("call resquest not available currently with this mechanic!",style: GoogleFonts.lato(
                        color: Colors.grey
                    ),),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),





    );
  }

  _Loadmechanic() async{

    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    Firestore.instance.collection('mechanic').document(widget.id).get().then((value){
      if(value.exists){
        if(!mounted) return;

        setState(() {
          _mechanic=value;
          load=false;
        });
      }
    });

getcurrentlocation();

  }


 _fill_distance() async{
   double distanceInMeters = await new Geolocator().distanceBetween(_position.latitude,_position.longitude,
        double.parse(_mechanic['lat'].toString()), double.parse(_mechanic['long'].toString()));
   if(!mounted) return;
   setState(() {
      distance=(distanceInMeters/1000).toStringAsFixed(2);
    });
   if(_position!=null){
     _getgeocodedaddress();
   }
  }

  getcurrentlocation() async{
    _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(_position==null){
      _position=await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    }
    _fill_distance();
  }



void _launchMapsUrl()   async {
  if(await IsConnectedtoInternet()){
    ShowInternetDialog(context);
    return;
  }
  final url = 'https://www.google.com/maps/dir/?api=1&origin=${_position.latitude},${_position.longitude}&destination=${_mechanic['lat']},${_mechanic['long']}&travelmode=driving';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
void _showissuedialog() {
    if(_address.isEmpty){
      Toast.show("Try after a second!", context,backgroundColor: Colors.black,textColor: grey,backgroundRadius: 5);
      return;
    }
  showDialog(
      barrierDismissible: false, context: context, builder: (context) {
    return alertbox(_mechanic,_address);
  });
}

_refreshavalability() async{

  subscription=Firestore.instance.collection('mechanic').document(widget.id).snapshots().listen((event) {
    if(event.exists){
      if(!mounted) return;

      setState(() {
        _mechanic=event;
      });
    }
  });
}


_getgeocodedaddress()async{
  if(!mounted) return;
  final coordinates = new Coordinates(
      _position.latitude, _position.longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(
      coordinates);
  var first = addresses.first;
  if(!mounted) return;
  setState(() {
    _address= ' ${first.locality}, ${first.adminArea},${first.subLocality},'
        ' ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare!=null?first.thoroughfare:""}, ${first.subThoroughfare!=null?first.subThoroughfare:""}';
    _address=_address.replaceAll("null", "");
  });

}

@override
  void dispose() {
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}
