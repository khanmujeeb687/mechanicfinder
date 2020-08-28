import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/themes/light_color.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/My_account.dart';
import 'package:forveel_partner/ui/Pages/home.dart';
import 'package:forveel_partner/ui/Start/Login/Login.dart';
import 'package:forveel_partner/ui/Widget/Settings/Pickupsettings.dart';
import 'package:forveel_partner/ui/Widget/Settings/ServiceSettings.dart';
import 'package:forveel_partner/ui/Widget/Settings/VehicleSettings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class drawer extends StatefulWidget {
  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: LightColor.black,
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: LightColor.lightGrey,
              child: ListTile(
                contentPadding: EdgeInsets.all(20),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CircleAvatar(
                    radius: 30,
                    child: CachedNetworkImage(
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      imageUrl: Home.userdata['photo'],
                      placeholder: (context, url) => SpinKitCircle(color: grey,),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                title: Text(Home.userdata['name'][0].toString().toUpperCase()+Home.userdata['name'].toString().substring(1),style: GoogleFonts.lato(color: LightColor.lightblack,fontSize: 20,fontWeight: FontWeight.w300)),
                onTap: (){
                  Navigator.push(context, PageTransition(
                      child: MechanicPageUID(Home.userdata),
                      duration: Duration(milliseconds: 10),
                      type: PageTransitionType.fade
                  ));
                },
              ),
            ),
            Divider(height: 1,),
            ExpansionTile(
              title: Text("Settings",style: GoogleFonts.lato(color: grey),),
              leading: Icon(Icons.settings,color: LightColor.orange,),
              children: <Widget>[
                ListTile(
                  onTap: (){
                    Navigator.push(context, PageTransition(
                        child: VehicleSettings(),
                        duration: Duration(milliseconds: 10),
                        type: PageTransitionType.fade
                    ));
                  },
                  title: Text("Vehicle Settings",style: GoogleFonts.lato(color: grey),),
                  leading: Icon(Icons.directions_car,color: grey,),
                  subtitle: Text("Set up your prefrences of vehicle brands",style: GoogleFonts.lato(color: grey,fontWeight: FontWeight.w300,fontSize: 10),),
                ) ,
                Divider(height: 1,),
                ListTile(
                  onTap: (){
                    Navigator.push(context, PageTransition(
                        child: ServiceSettings(),
                        duration: Duration(milliseconds: 10),
                        type: PageTransitionType.fade
                    ));
                  },
                  title: Text("Service Settings",style: GoogleFonts.lato(color: grey),),
                  leading: Icon(Icons.airline_seat_recline_extra,color: grey,),
                  subtitle: Text("Set up your prefrences of vehicle brands",style: GoogleFonts.lato(color: grey,fontWeight: FontWeight.w300,fontSize: 10),),
                ),
                Divider(height: 1,),
                ListTile(
                  onTap: (){
                    Navigator.push(context, PageTransition(
                        child: PickupSetting(),
                        duration: Duration(milliseconds: 10),
                        type: PageTransitionType.fade
                    ));
                  },
                  title: Text("Pickup settings",style: GoogleFonts.lato(color: grey),),
                  leading: Icon(FontAwesomeIcons.carAlt,color: grey,),
                  subtitle: Text("Set up if you provide pickup or not",style: GoogleFonts.lato(color: grey,fontWeight: FontWeight.w300,fontSize: 10),),

                ),
              ],
            ),

            Divider(height: 1,),
            ExpansionTile(
              title: Text("Logout",style: GoogleFonts.lato(color: grey),),
              leading: Icon(FontAwesomeIcons.signOutAlt,color: LightColor.orange,),
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
                          child: Login(),
                          duration: Duration(milliseconds: 10),
                          type: PageTransitionType.fade
                      ));
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
