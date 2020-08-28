import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';

import 'Addressbox.dart';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {


  Position _position;
  String _address;
  String _city;
  double pinpill;
  int a;
  bool move=true;


  static const LatLng _center = const LatLng(28.555229, 77.285257);
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _mapController = Completer();
  MapType _currentMapType = MapType.normal;
  GoogleMapController _mapcontroller;


  @override
  void initState() {
    pinpill=-500;
    a=0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            onCameraMove: _oncameramove,
            mapType: _currentMapType,
            onCameraIdle: (){
              if(a==1){
                setState(() {
                  _getgeocodedaddress(_position);
                  pinpill=80;
                });
                a=0;
              }

            },
          ),

          Addressbox(_address,pinpill)
          ,
          Align(
            alignment: Alignment.centerRight,
            child:  Container(
              padding: EdgeInsets.all(20),
              child: FloatingActionButton(
                backgroundColor: background,
                child: Icon(Icons.arrow_forward,color: blue,),
                onPressed: ()async{
                  bool waiter=await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context){
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          title: Text("Are you sure you wants to submit this address?",style: GoogleFonts.lato(color: grey),),
                          actions: <Widget>[
                            OutlineButton(
                              child: Text("Yes",style: GoogleFonts.lato(color: green),),
                              onPressed: (){
                                if(_city!=null && _address!=null && _position!=null){
                                  Navigator.pop(context,true);
                                }else{
                                  Toast.show("Please select a location!", context);
                                }
                              },
                            ),
                            OutlineButton(
                              child: Text("Cancel",style: GoogleFonts.lato(color: voilet),),
                              onPressed: (){
                                Navigator.pop(context,false);
                              },
                            ),
                          ],
                        );
                      }

                  );
                  if(waiter){
                    Navigator.pop(context,{
                      "address":_address,
                      "city":_city,
                      "lat":_position.latitude.toString(),
                      "long":_position.longitude.toString()
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }







  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    _mapcontroller=controller;
    getcurrentlocation();
  }

  _addusermarker(Position position)
  {
    MarkerId markerId = MarkerId("mid");
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(position.latitude,position.longitude),
        draggable: false,
        icon: BitmapDescriptor.fromAsset("assets/images/mechanic.png")
    );
    if(!mounted) return;
    setState(() {
      _markers[markerId] = marker;
    });

  }


  getcurrentlocation() async {

    _position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (_position == null) {
      _position = await Geolocator().getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    }
    _getgeocodedaddress(_position);
  }




  _getgeocodedaddress(Position position)async{
    _position=Position(latitude:position.latitude,longitude: position.longitude);
    if(!mounted) return;
    if(move){
      _mapcontroller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_position.latitude,_position.longitude),
            zoom: 18,
          ),
        ),
      );
      move=false;
    }
    final coordinates = new Coordinates(
        position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    if(!mounted) return;
    setState(() {
      pinpill=80;
      _address= ' ${first.locality}, ${first.adminArea},${first.subLocality},'
          ' ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare!=null?first.thoroughfare:""}, ${first.subThoroughfare!=null?first.subThoroughfare:""}';
      _address=_address.replaceAll("null", "");
    });
    _city=first.locality;
    _addusermarker(_position);

  }


  void _oncameramove(CameraPosition position) {
    a=1;
    _position=Position(latitude: position.target.latitude,longitude: position.target.longitude);
    if(_markers.length > 0) {
      MarkerId markerId = MarkerId("mid");
      Marker marker = _markers[markerId];
      Marker updatedMarker = marker.copyWith(
        positionParam: position.target,
      );
      if(!mounted) return;
      setState(() {
        pinpill=-500;
        _markers[markerId] = updatedMarker;
      });

    }
  }
}
