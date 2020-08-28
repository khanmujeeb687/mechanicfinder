import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/ui/Mycolors.dart';

import 'package:google_fonts/google_fonts.dart';


class VtypesShow extends StatelessWidget {
  List<dynamic> vtypes;
  List<dynamic> two;
  List<dynamic> four;
  VtypesShow(this.vtypes,this.four,this.two);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      alignment: Alignment.center,
      child:ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(vtypes.length, (index){
          return Container(
            margin: EdgeInsets.only(left: 6,right: 6),
            alignment: Alignment.center,
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              onPressed: (){},
              borderSide: BorderSide(color: voilet),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  (){
                  if(vtypes[index]=="tw"){
                    return Icon(Icons.motorcycle,color: voilet);
                  }
                  else{
                    return Icon(Icons.directions_car,color: voilet);
                  }
                  }(),
                  SizedBox(width: 5,),
                      (){
                    if(vtypes[index]=="tw"){
                      return Text("Two wheeler",style:GoogleFonts.lato(color: voilet),);
                    }
                    else{
                      return Text("Four wheeler",style:GoogleFonts.lato(color: voilet),);
                    }
                  }(),SizedBox(width: 5,),
                      (){
                    if(vtypes[index]=="tw"){
                      return  PopupMenuButton<dynamic>(
                        color: background,
                        icon: Icon(Icons.more_horiz,color: voilet,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 10,
                        itemBuilder: (BuildContext context) {
                          return two.map((dynamic choice) {
                            return PopupMenuItem<dynamic>(
                                value: choice,
                                child:Text(choice,style: GoogleFonts.lato(color: grey),)
                            );
                          }).toList();
                        },
                      );
                    }
                    else{
                      return  PopupMenuButton<dynamic>(
                        color: background,
                        icon: Icon(Icons.more_horiz,color: voilet,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 10,
                        itemBuilder: (BuildContext context) {
                          return four.map((dynamic choice) {
                            return PopupMenuItem<dynamic>(
                                value: choice,
                                child:Text(choice,style: GoogleFonts.lato(color: grey),)
                            );
                          }).toList();
                        },
                      );
                    }
                  }(),

                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}


class Skills extends StatelessWidget {
  List<dynamic> types;
  Skills(this.types);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      alignment: Alignment.center,
      child:ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(types.length, (index){
          return Container(
            margin: EdgeInsets.only(left: 6,right: 6),
            alignment: Alignment.center,
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              onPressed: (){},
              borderSide: BorderSide(color: voilet),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    Icon(FontAwesomeIcons.searchengin,color: voilet),
                    SizedBox(width: 5,),
                    Text(repair(types[index]),style:GoogleFonts.lato(color: voilet),)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
  String repair(value) {
    value=value.replaceAll("_", " ");
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }

}




