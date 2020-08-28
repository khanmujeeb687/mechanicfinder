import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/Resources/themes/light_color.dart';
import 'package:forveel/Resources/themes/theme.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/Diagnose_page.dart';
import 'package:forveel/ui/Pages/mechanic_page_uid.dart';
import 'package:forveel/ui/Pages/search_page.dart';
import 'package:forveel/ui/Pages/shopping_page.dart';
import 'package:forveel/ui/Widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:forveel/ui/Widgets/Home/bottom_navigation.dart';
import 'package:forveel/ui/Widgets/Home/qr.dart';
import 'package:forveel/ui/Widgets/Puncture/Snaps.dart';
import 'package:forveel/ui/Widgets/Request/alertbox.dart';
import 'package:forveel/ui/Widgets/Search/mechanic_card.dart';
import 'package:forveel/ui/Widgets/Start/register.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/Request/change_car.dart';
import '../loader_dialog.dart';
import 'history_page.dart';

class Home extends StatefulWidget {

  static String notifications="0";
 static DocumentSnapshot userdata;
  Home(a){
    userdata=a;
  }
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List<DocumentSnapshot> _mechanics;
 static List<DocumentSnapshot> _mechanicsstore;
  static Position _position;
  double PinPillPosition;
  int pinindex;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(28.555229,77.285257);
  static GoogleMapController _mapcontroller;
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  CustomPopupMenu choice;
  List<DocumentSnapshot> _onlypuncture=[];
  List<DocumentSnapshot> _puncturefiltered;
  bool _puncture=false;
  List<CustomPopupMenu> filters=[];
  String filtertitle="Puncture";

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _mapcontroller=controller;
    });

  }
  var geolocator = Geolocator();
  StreamSubscription<Position> positionStream;
  var locationOptions;
  @override
  void initState() {
    _setup_filter_menu();
locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
   positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
if(position!=null){
  setState(() {
    _position=position;
  });
}
            });


    PinPillPosition=-100;
_getCurrentLocation();
    super.initState();
  }

  var _key=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        SystemNavigator.pop();
        return Future.value(true);
        },
      child: Scaffold(
        key: _key,
        drawer: Drawer(
          child: drawer()
        ),
        backgroundColor: background,

        body: Stack(
          children: <Widget>[
            GoogleMap(

                mapToolbarEnabled: true,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onTap: (LatLang) {
                  setState(() {
                    PinPillPosition =-100;
                  });
                }
            ),
            infowindowcustom(),

            Align(
              alignment: Alignment.bottomRight,
              child:   Container(
                margin: EdgeInsets.fromLTRB(0, 0, 18, 180),
                child: FloatingActionButton(
                  elevation: 10,
                  backgroundColor: textc,

                  child: Icon(Icons.my_location),

                  onPressed: (){

                    setState(() {

                      PinPillPosition=-100;
                    });

                    _mapcontroller.animateCamera(

                      CameraUpdate.newCameraPosition(

                        CameraPosition(

                          target: LatLng(_position.latitude,_position.longitude),

                          zoom: 13.0,

                        ),

                      ),
                    );
                  },

                ),
              ),
            ),
            PunctureButton(),
            _detailWidget()
          ],
        ),
      ),
    );
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: 1,
      initialChildSize: .3,
      minChildSize: .1,
      builder: (context, scrollController) {
        return Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Color(0xfffbfbfb),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(0),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CustomBottomNavigationBar(
                  onIconPresedCallback: onBottomIconPressed,
                ),
                Container(
                  height: MediaQuery.of(context).size.height-100,
                    width: MediaQuery.of(context).size.width,
                    child:(){ if(_mechanics!=null){
                      if(_puncture){
                        if(_puncturefiltered==null){
                          return Container(alignment: Alignment.topCenter,child: SpinKitCircle(color: grey,duration: Duration(milliseconds: 100),),);
                        }else if(_puncturefiltered.isEmpty){
                          return Center(child: Text("No punture shop around you!",style: GoogleFonts.lato(color: grey),));
                        }
                        return Container(
                          alignment: Alignment.center,
                          child: Snaps(_puncturefiltered,_position),
                        );
                      }
                      return  Container(
                        alignment: Alignment.center,
                        child: ListView.builder(
                          controller: scrollController,
                            itemCount: _mechanics.length,
                            itemBuilder: (context,index){
                              return MechanicCard(_mechanics[index]);
                            }),
                      );
                    }else{
                      return Center(child: SpinKitCircle(color: grey,duration: Duration(milliseconds: 100),));

                    }
                    }()
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void onBottomIconPressed(int index) {
    switch(index){
      case 0:{
        _key.currentState.openDrawer();
      }
      break;
      case 1:{
        Navigator.push(context, PageTransition(
                child: DiagnosePage(),
                type: PageTransitionType.scale,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.bottomLeft
            ));
      }
      break;
      case 2:{

      }
      break;
      case 3:{
        Navigator.push(context, PageTransition(
                child: ShoppingPage(),
                type: PageTransitionType.scale,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.bottomRight
            ));
      }
      break;
      case 4:{
        Navigator.push(context, PageTransition(
                    child: HistoryPage(),
                    type: PageTransitionType.scale,
                    duration: Duration(milliseconds: 300),
                    alignment: Alignment.bottomRight
                ));
      }
      break;
    }
  }
  _loadmechanic() async {
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }

    String city = await _GetCurrentCity();
    print(city);
    Firestore.instance.collection('mechanic').where('verified',isEqualTo: true).where("onlypuncture",isEqualTo:false).getDocuments().then((value){
      _mechanics=value.documents;
      _mechanicsstore=value.documents;
      filters.add(CustomPopupMenu(icon: Icons.remove,onclick:(){filtertitle="Filter";_removefilters(_mechanics);},title: "Normal view"));
      print(_mechanicsstore.length);
      print(_mechanics.length);
      if(_mechanics.isNotEmpty){
        _LoadMarkersFromDatabase();
      }
      else{
        Toast.show("We don't have mechanics near you!",
            context,backgroundColor: pink,textColor: background,gravity: Toast.TOP,duration: Toast.LENGTH_LONG);
      }
    });

  }

  _loaduser()async{
    _mapcontroller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_position.latitude,_position.longitude),
          zoom: 13.0,
        ),
      ),
    );
    _loadmechanic();
  }

  Widget infowindowcustom()
  {
    if(_mechanics==null || pinindex==null){
      return Container();
    }
    return AnimatedPositioned(
      top: PinPillPosition,right: 0,left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: background
                  ),
        child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

               Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 50, height: 50,
                          child: ClipOval(
                              child:
                              (_mechanics[pinindex]["photo"].isEmpty || _mechanics[pinindex]["photo"]==null)?Image.asset(
                                  "assets/images/mechanic.png",
                                  fit: BoxFit.cover):
                              CachedNetworkImage(
                                imageUrl: _mechanics[pinindex]["photo"],
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              )                        )
                      ),

                    Expanded(
                        child: GestureDetector(
                          child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                  Text(
                                    "${_mechanics[pinindex]["shopname"]}(${_mechanics[pinindex]["name"]})"
                                     ,
                                  style: GoogleFonts.lato(
                                      color: myyellow
                                  ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 2,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(int.parse(_mechanics[pinindex]["rating"]['value'].toString().split(".")[0]).floor(), (index){
                                  return Icon(FontAwesomeIcons.solidStar,color: Colors.yellow,size: 10,);
                                })

                              ),
                          Text( _mechanics[pinindex]["address"],
                          style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.grey
                          ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                    )], // end of Column Widgets
        ),  // end of Column
              ),
                            onTap: (){
                              Navigator.push(context, PageTransition(
                                  child: MechanicPageUID(_mechanics[pinindex].documentID,_mechanics[pinindex]),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 100)
                              ));
                            }  ),  // end of Container
      ),
                    GestureDetector(
                      child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.directions,color: myyellow,),
                              Text("Directions",style: GoogleFonts.lato(fontSize: 10,color: Colors.grey),)
                            ],
                          ),
                        ),
                      onTap: _launchMapsUrl,
                    ) // third w// idget
                  ]
              )
              ),
            ),
          )
      ),

    );
  }

Future<String> _GetCurrentCity()
  async{
    try {
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      return placemark[0].locality.toString();
    }catch(e){
Toast.show(e.toString(), context,gravity: Toast.TOP);
    }
  }

  _LoadMarkersFromDatabase()
  async{
    if(_mechanics.isNotEmpty){

      for(int i=0;i<_mechanics.length;i++)
        {
          _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(_mechanics[i].documentID),
              position: LatLng(double.parse(_mechanics[i]['lat'].toString()),double.parse(_mechanics[i]['long'].toString())),
              // ignore: deprecated_member_use
              icon:BitmapDescriptor.fromAsset( "assets/images/mechanic.png") ,
              onTap: () {
                setState(() {
                  pinindex=i;
                  PinPillPosition=100;
                });
              }
          ));
        }
      setState(() {
        _mechanics=_mechanics;
        _markers=_markers;
      });
    }
  }





  _getCurrentLocation()async{
   _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(_position==null){
      _position=await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    }
    setState(() {
      _position=_position;
    });
    _loaduser();
  }



  void _launchMapsUrl() async {
    if(await IsConnectedtoInternet()){
      ShowInternetDialog(context);
      return;
    }
    final url = 'https://www.google.com/maps/dir/?api=1&origin=${_position.latitude},${_position.longitude}&destination=${_mechanics[pinindex]["lat"]},${_mechanics[pinindex]["long"]}&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


_getpunctured(String selection) async{
    LoaderDialog(context, false);
    List<DocumentSnapshot> temp=[];
    if(_onlypuncture.isEmpty){
    await Firestore.instance.collection("mechanic").where("verified",isEqualTo: true).where("onlypuncture",isEqualTo: true).getDocuments().then((value){
        if(value.documents.isNotEmpty){
          _onlypuncture=value.documents;
        }
      });
    }
    switch(selection){
      case "two":{
        for(int i=0;i<_onlypuncture.length;i++){
          if(_onlypuncture[i]['twowheelpuncture']==true){
            temp.add(_onlypuncture[i]);
          }
        }
      }
      break;
      case "three":{
        for(int i=0;i<_onlypuncture.length;i++){
          if(_onlypuncture[i]['threewheelpuncture']==true){
            temp.add(_onlypuncture[i]);
          }
        }
      }
      break;
      case "four":{
        for(int i=0;i<_onlypuncture.length;i++){
          if(_onlypuncture[i]['fourwheelpuncture']==true){
            temp.add(_onlypuncture[i]);
          }
        }
      }
      break;
      case "more":{
        for(int i=0;i<_onlypuncture.length;i++){
          if(_onlypuncture[i]['morewheelpuncture']==true){
            temp.add(_onlypuncture[i]);
          }
        }
      }
      break;
      default:{
      }
    }
    List<DocumentSnapshot> temp2= _getselectedfromall(selection);
    temp.addAll(temp2);
    _puncturefiltered=temp;
    setState(() {
      _puncturefiltered=_puncturefiltered;
      _puncture=true;
    });
    _updatemarkersonfilter(_puncturefiltered);
Navigator.pop(context);
}

List<DocumentSnapshot> _getselectedfromall(String selection){
    setState(() {
      PinPillPosition=-100;
    });
    List<DocumentSnapshot> temp=[];
    if(_mechanics!=null && _mechanics.isNotEmpty){
      switch(selection){
        case "two":{
          for(int i=0;i<_mechanics.length;i++){
            if(_mechanics[i]['twowheelpuncture']==true){
              temp.add(_mechanics[i]);
            }
          }
        }
        break;
        case "three":{
          for(int i=0;i<_mechanics.length;i++){
            if(_mechanics[i]['threewheelpuncture']==true){
              temp.add(_mechanics[i]);
            }
          }
        }
        break;
        case "four":{
          for(int i=0;i<_mechanics.length;i++){
            if(_mechanics[i]['fourwheelpuncture']==true){
              temp.add(_mechanics[i]);
            }
          }
        }
        break;
        case "more":{
          for(int i=0;i<_mechanics.length;i++){
            if(_mechanics[i]['morewheelpuncture']==true){
              temp.add(_mechanics[i]);
            }
          }
        }
        break;
        default:{

        }
      }
    }
    return temp;
}
_removefilters(List<DocumentSnapshot> _mechanics){
  _markers.clear();
  for(int i=0;i<_mechanics.length;i++)
  {
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_mechanics[i].documentID),
      position: LatLng(double.parse(_mechanics[i]['lat'].toString()),double.parse(_mechanics[i]['long'].toString())),
      // ignore: deprecated_member_use
      icon:BitmapDescriptor.fromAsset( "assets/images/mechanic.png") ,
        onTap: () {
          setState(() {
            pinindex=i;
            PinPillPosition=100;
          });
        }
    ));
  }
  setState(() {
    _markers=_markers;
    _puncture=false;
    filtertitle="Puncture";
  });
  _mapcontroller.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(_position.latitude,_position.longitude),
        zoom: 13.0,
      ),
    ),
  );
}




  Widget PunctureButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        duration: Duration(milliseconds: 600),
        margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
        child: Card(
          color: LightColor.lightblack,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(filtertitle,style: GoogleFonts.lato(color: background),textAlign: TextAlign.center,),
                PopupMenuButton<CustomPopupMenu>(
                  color:  Color(0xfffbfbfb),
                  icon: Icon(Icons.keyboard_arrow_down,color: LightColor.orange,),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 10,
                  onSelected: (choice){
                    choice.onclick();
                  },
                  itemBuilder: (BuildContext context) {
                    return filters.map((CustomPopupMenu choice) {
                      return PopupMenuItem<CustomPopupMenu>(
                        value: choice,
                        child:Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(choice.icon,color: grey,),
                            Text(choice.title,style: GoogleFonts.lato(color:grey),)
                          ],
                        ),
                      );
                    }).toList();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updatemarkersonfilter(List<DocumentSnapshot> _mechanics){
    _markers.clear();
    for(int i=0;i<_mechanics.length;i++)
    {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_mechanics[i].documentID),
          position: LatLng(double.parse(_mechanics[i]['lat'].toString()),double.parse(_mechanics[i]['long'].toString())),
          // ignore: deprecated_member_use
          icon:BitmapDescriptor.fromAsset( "assets/images/worker.png") ,

      ));
    }
    setState(() {
      _markers=_markers;
    });
    _mapcontroller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_position.latitude,_position.longitude),
          zoom: 13.0,
        ),
      ),
    );
  }




  _setup_filter_menu(){
    filters=[
        CustomPopupMenu(icon: Icons.motorcycle,onclick:(){filtertitle="Two wheeler puncture";_getpunctured("two");},title: "Two wheeler"),
        CustomPopupMenu(icon: Icons.directions_railway,onclick:(){filtertitle="Three wheeler puncture";_getpunctured("three");},title: "Three wheeler"),
        CustomPopupMenu(icon: Icons.directions_car,onclick: (){filtertitle="Four wheeler puncture";_getpunctured("four");},title: "Four wheeler"),
        CustomPopupMenu(icon: Icons.directions_bus,onclick:(){filtertitle="Heavy vehicle puncture";_getpunctured("more");},title: "More than Four"),
      ];

    setState(() {
      filters=filters;
    });
  }

  List<Map> _bikes=
  [{'name':'Honda','value':false},
    {'name':'Hero','value':false},
    {'name':'BMW','value':false},
    {'name':'TVS','value':false},
    {'name':'Bajaj','value':false},
    {'name':'Yamaha','value':false},
    {'name':'Royal Enfield','value':false},
    {'name':'Suzuki','value':false},
    {'name':'Piaggio','value':false},
    {'name':'Mahindra','value':false},
    {'name':'UM Lohia','value':false},];
  List<Map> _car=
  [{'name':'Maruti Suzuki','value':false},
    {'name':'Toyota','value':false},
    {'name':'Hyundai','value':false},
    {'name':'Tata','value':false},
    {'name':'Jeep','value':false},
    {'name':'Ford','value':false},
    {'name':'MG Motor','value':false},
    {'name':'Honda','value':false},
    {'name':'Mahindra','value':false},
    {'name':'Kia','value':false},
    {'name':'Volkswagen','value':false},
    {'name':'Renault','value':false},
    {'name':'BMW','value':false},
    {'name':'Mercedes Benz','value':false},
    {'name':'Datsun','value':false},
    {'name':'Volvo','value':false},
    {'name':'Fiat','value':false},
    {'name':'Audi','value':false},
    {'name':'Skoda','value':false},
    {'name':'Mitsubishi','value':false},
    {'name':'Nissan','value':false},
    {'name':'jaguar','value':false},
    {'name':'Lamborghini','value':false},
    {'name':'Rolls Royce','value':false},
    {'name':'Mini','value':false},
    {'name':'Bugati','value':false},
    {'name':'Aston Martin','value':false},
    {'name':'Land Rover','value':false},
    {'name':'Bentley','value':false},
    {'name':'Force Motor','value':false},
    {'name':'Tesla','value':false},
    {'name':'Porche','value':false},
    {'name':'Ferrari','value':false},
    {'name':'Maserati','value':false},
    {'name':'ISUZU','value':false},
    {'name':'Bajaj','value':false},
    {'name':'DC','value':false},
    {'name':'Premier','value':false},
    {'name':'Haval','value':false},
    {'name':'Lexus','value':false},
    {'name':'Chevrolet','value':false},
    {'name':'Citroen','value':false},
  ];
  bool twov=false;
  bool fourv=false;
  List<bool> basedonservice=[false,false,false,false,false];
  List<String> typeslist=["mechanic","electrician","ac_repair","denter/painter","car_scanning"];
  List<int> abort=[];

  Widget drawer() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Container(
            padding: EdgeInsets.all(6),
            width: MediaQuery.of(context).size.width-30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: LightColor.lightblack,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, PageTransition(
                      child: SearchPage(),
                      type: PageTransitionType.scale,
                      alignment: Alignment.bottomCenter,
                      duration: Duration(milliseconds: 200)
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.search,color: LightColor.orange,),
                    Text("Search",style: GoogleFonts.lato(color: LightColor.background),),
                  ],
                ),
              ),
            ),
          ),
        ),
        ListTile(
          title: Text("Qr code",style: AppTheme.titleStyle,),
          leading: Icon(FontAwesomeIcons.qrcode,color: LightColor.orange,),
          onTap: (){
            Navigator.push(context, PageTransition(
                child: QR(),
                type: PageTransitionType.scale,
                alignment: Alignment.topLeft,
                duration: Duration(milliseconds: 250)
            ));
          },
        ),
        Divider(),
        ListTile(
          trailing: RaisedButton(
            onPressed: (){
              Navigator.pop(context);
              _applyfilter();
            },
            color: green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Apply",style: GoogleFonts.lato(color:background),),
          ),leading: RaisedButton(
            onPressed: (){
           twov=false;
           fourv=false;
           basedonservice=[false,false,false,false,false];
           _applyfilter();
           Navigator.pop(context);
            },
            color: voilet,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Remove",style: GoogleFonts.lato(color:background),),
          ),
          title: Text("Filters",style: GoogleFonts.lato(color: grey,fontWeight: FontWeight.w400,fontSize: 20),),
        ),
        Divider(height: 1,),
        ExpansionTile(
          title: Text("Based on service",style: GoogleFonts.lato(color: Colors.black),),
          children: <Widget>[
            ListTile(
              leading: Checkbox(
                activeColor: green,
                value: basedonservice[0],
                onChanged: (a){
                  setState(() {
                    basedonservice[0]=a;
                  });
                },
              ),
              title: Text("Mechanic",style: GoogleFonts.lato(color: grey,fontSize: 14),),
            ),
            Divider(height: 1,), ListTile(
              leading: Checkbox(
                activeColor: green,
                value: basedonservice[1],
                onChanged: (a){
                  setState(() {
                    basedonservice[1]=a;
                  });
                },
              ),
              title: Text("Vehicle AC repair",style: GoogleFonts.lato(color: grey,fontSize: 14),),

            ),
            Divider(height: 1,),
            ListTile(
              leading: Checkbox(
                activeColor: green,
                value: basedonservice[2],
                onChanged: (a){
                  setState(() {
                    basedonservice[2]=a;
                  });
                },
              ),
              title: Text("Electrician",style: GoogleFonts.lato(color: grey,fontSize: 14),),

            ),
            Divider(height: 1,),
            ListTile(
              leading: Checkbox(
                activeColor: green,
                value: basedonservice[3],
                onChanged: (a){
                  setState(() {
                    basedonservice[3]=a;
                  });
                },
              ),
              title: Text("Denter/Painter",style: GoogleFonts.lato(color: grey,fontSize: 14),),

            ),
            Divider(height: 1,),
            ListTile(
              leading: Checkbox(
                activeColor: green,
                value: basedonservice[4],
                onChanged: (a){
                  setState(() {
                    basedonservice[4]=a;
                  });
                },
              ),
              title: Text("Car scanning",style: GoogleFonts.lato(color: grey,fontSize: 14),),

            ),
            Divider(height: 1,),
          ],
        ),
        Divider(height: 1,),
        ExpansionTile(
          title: Text("Based on vehicle type",style: GoogleFonts.lato(color: Colors.black),),
          children: <Widget>[
            ExpansionTile(
              leading: Checkbox(
                activeColor: green,
                value: twov,
                onChanged: (a){
                  setState(() {
                    for(int i=0;i<_bikes.length;i++){
                      _bikes[i]['value']=a;
                    }
                    twov=a;
                  });
                },
              ),
              title: Text("Two wheeler",style: GoogleFonts.lato(color: grey,fontSize: 14),),
              children: List.generate(_bikes.length, (index){
                return ListTile(
                  title: Text(_bikes[index]['name'],style: GoogleFonts.lato(color: grey,fontSize: 14),),
                  trailing: Checkbox(
                    activeColor: pink,
                    value: _bikes[index]['value'],
                    onChanged: (a){
                      setState(() {
                        bool temp=false;
                        _bikes[index]['value']=a;
                        if(a){
                          twov=true;
                        }else{
                          for(int i=0;i<_bikes.length;i++){
                            if(_bikes[i]['value']){
                              temp=true;
                            }
                          }
                          twov=temp;
                        }
                      });
                    },
                  ),
                );
              }),
            ),
            Divider(height: 1,), ExpansionTile(
              leading: Checkbox(
                activeColor: green,
                value: fourv,
                onChanged: (a){
                  setState(() {
                    for(int i=0;i<_car.length;i++){
                      _car[i]['value']=a;
                    }
                    fourv=a;
                  });
                },
              ),
              title: Text("Four wheeler",style: GoogleFonts.lato(color: grey,fontSize: 14),),
              children:List.generate(_car.length, (index){
                return ListTile(
                  title: Text(_car[index]['name'],style: GoogleFonts.lato(color: grey,fontSize: 14),),
                  trailing: Checkbox(
                    activeColor: pink,
                    value: _car[index]['value'],
                    onChanged: (a){
                      setState(() {
                        bool temp=false;
                        _car[index]['value']=a;
                        if(a){
                          fourv=true;
                        }else{
                          for(int i=0;i<_car.length;i++){
                            if(_car[i]['value']==true){
                              temp=true;
                            }
                          }
                          fourv=temp;
                        }
                      });
                    },
                  ),
                );
              }),
            ),

          ],
        ),
        Divider(height: 1,),

        ExpansionTile(
          title: Text("Logout",style: GoogleFonts.lato(color: grey),),
          leading: Icon(FontAwesomeIcons.signOutAlt,color: grey,),
          children: <Widget>[
            ListTile(
              title: Text("Are you sure!",style: GoogleFonts.lato(color: Colors.redAccent),),
              leading: Icon(Icons.exit_to_app,color: Colors.redAccent,),
              trailing: OutlineButton(
                color: Colors.red,
                borderSide: BorderSide(color: Colors.red),
                child: Text("Yes",style: GoogleFonts.lato(color: Colors.red),),
                onPressed: ()async{
                  SharedPreferences prefs=await SharedPreferences.getInstance();
                  prefs.setString('userlogin', "0");
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context, PageTransition(
                      child: Register(),
                      duration: Duration(milliseconds: 10),
                      type: PageTransitionType.fade
                  ));
                },
              ),
            )
          ],
        )
      ],
    );
  }

  void _applyfilter(){
      abort.clear();
    _mechanics.clear();
    _mechanics.addAll(_mechanicsstore);
    print(_mechanicsstore.length);
    if(basedonservice.contains(true) || twov==true || fourv==true){
      _mechanics.clear();
    }
      for(int j=0;j<typeslist.length;j++){
        if(basedonservice[j]){
      for(int i=0;i<_mechanicsstore.length;i++){
        if(abort.contains(i)) continue;
        if(_mechanicsstore[i]['types'].contains(typeslist[j])){
          if(!_mechanics.contains(_mechanicsstore[i])){
            _mechanics.add(_mechanicsstore[i]);
          }
        }else{
          if(!abort.contains(i)){
            abort.add(i);
          }
          if(_mechanics.contains(_mechanicsstore[i])){
            _mechanics.remove(_mechanicsstore[i]);

          }
        }
        }
      }
    }
      if(twov){
        for(int i=0;i<_bikes.length;i++){
       if(_bikes[i]['value']){
         for(int j=0;j<_mechanicsstore.length;j++){
           if(abort.contains(j)) continue;
           if(_mechanicsstore[j]['Two wheeler'].contains(_bikes[i]['name'])){
             if(!_mechanics.contains(_mechanicsstore[j])){
               _mechanics.add(_mechanicsstore[j]);
             }
           }else{
             if(!abort.contains(j)){
               abort.add(j);
             }
             if(_mechanics.contains(_mechanicsstore[j])){
               _mechanics.remove(_mechanicsstore[j]);
             }
           }
         }
       }
        }
      }
      if(fourv){
        for(int i=0;i<_car.length;i++){
       if(_car[i]['value']){
         for(int j=0;j<_mechanicsstore.length;j++){
           if(abort.contains(j)) continue;
           if(_mechanicsstore[j]['Four wheeler'].contains(_car[i]['name'])){
             if(!_mechanics.contains(_mechanicsstore[j])){
               _mechanics.add(_mechanicsstore[j]);
             }
           }else{
             if(!abort.contains(j)){
               abort.add(j);
             }
             if(_mechanics.contains(_mechanicsstore[j])){
               _mechanics.remove(_mechanicsstore[j]);

             }
           }
         }
       }
        }
      }

      setState(() {
        PinPillPosition=-100;
        pinindex=null;
        _mechanics=_mechanics;
      });
    _removefilters(_mechanics);
  }
}

class mymenuitem{
  Icon icon;
  Text text;
  mymenuitem(this.icon,this.text);
}