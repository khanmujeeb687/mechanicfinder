
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forveel_partner/Resources/themes/light_color.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Pages/home.dart';
import 'package:forveel_partner/ui/Widget/Settings/Addbrands.dart';
import 'package:forveel_partner/ui/loader_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
class VehicleSettings extends StatefulWidget {
  @override
  _VehicleSettingsState createState() => _VehicleSettingsState();
}

class _VehicleSettingsState extends State<VehicleSettings> {

  List<bool> switches=[false,false];
  DocumentSnapshot _user;

  @override
  void initState() {
    _user=Home.userdata;
    if(Home.userdata['vehicle_type'].contains("tw")){
    switches[0]=true;
    }

    if(Home.userdata['vehicle_type'].contains("fw")){
    switches[1]=true;
    }

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: LightColor.black,
        title: Text("Vehicle Settings",style: GoogleFonts.lato(color: grey),textAlign: TextAlign.center,),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: background,
        child: ListView(
          padding: EdgeInsets.all(6),
          children: <Widget>[
            ListTile(
              enabled: switches[0],
              title: Text("Two wheeler",style: GoogleFonts.lato(color: grey),),
              subtitle: (){
                if(_user['Two wheeler'].isNotEmpty){
                  return Text(_user['Two wheeler'].toString().replaceAll("[", " ").replaceAll("]", ""),
                    style: GoogleFonts.lato(color: grey,fontSize: 10,fontWeight: FontWeight.w300),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );

                }
                return Text("Set up vehicle brands",style: GoogleFonts.lato(color: grey,fontSize: 10,fontWeight: FontWeight.w300),);
              }(),leading: Icon(Icons.motorcycle,color: LightColor.orange,),
              trailing: Switch(
                value: switches[0],
                onChanged: (a){
                  _switched(a, 0);
                },
              ),
              onTap: ()async{
               await Navigator.push(context, PageTransition(
                    child: AddBrands("Two wheeler"),
                    duration: Duration(milliseconds: 10),
                    type: PageTransitionType.fade
                ));
               setState(() {
                 _user=Home.userdata;
               });
              },
            ),
            Divider(height: 1,),
            ListTile(
              enabled: switches[1],
              title: Text("Four wheeler",style: GoogleFonts.lato(color: grey),),
              subtitle:
                  (){
                if(_user['Four wheeler'].isNotEmpty){
                  return Text(_user['Four wheeler'].toString().replaceAll("[", " ").replaceAll("]", ""),
                    style: GoogleFonts.lato(color: grey,fontSize: 10,fontWeight: FontWeight.w300),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );

                }
                return Text("Set up vehicle brands",style: GoogleFonts.lato(color: grey,fontSize: 10,fontWeight: FontWeight.w300),);
              }(),
              leading: Icon(Icons.directions_car,color:  LightColor.orange,),
              trailing: Switch(
                value: switches[1],
                onChanged: (a){
                  _switched(a, 1);
                },
              ),
              onTap: ()async{
               await Navigator.push(context, PageTransition(
                    child: AddBrands("Four wheeler"),
                    duration: Duration(milliseconds: 10),
                    type: PageTransitionType.fade
                ));
               setState(() {
                 _user=Home.userdata;
               });
              },
            ),
          ],
        ),
      ),
    );
  }

  _change(List<dynamic> list)async{
    LoaderDialog(context, false);
    await Firestore.instance.collection('mechanic').document(Home.userdata.documentID).updateData({'vehicle_type':list}).then((value){
      Firestore.instance.collection("mechanic").document(Home.userdata.documentID).get().then((value){
        Home.userdata=value;
        Navigator.pop(context);
      });
    });

  }

   _switched(bool a,int index){
    List<dynamic> temp=Home.userdata['vehicle_type'];
    switch(index){
      case 0:{
        setState(() {
          switches[index]=a;
        });
        if(a){
          if(!temp.contains("tw")){
            temp.add('tw');
          }
        }else{
          if(temp.contains("tw")){
            temp.remove('tw');
          }
        }
      }
      break;
      case 1:{
        setState(() {
          switches[index]=a;
        });
        if(a){
          if(!temp.contains("fw")){
            temp.add('fw');
          }
        }else{
          if(temp.contains("fw")){
            temp.remove('fw');

          }
        }
      }
      break;
      default :{
      }
    }
    _change(temp);
  }
}
