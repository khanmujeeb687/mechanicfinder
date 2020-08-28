import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Mycolors.dart';

class ChangeBike extends StatefulWidget {
  List<dynamic> two;
  ChangeBike(this.two);
  @override
  _ChangeBikeState createState() => _ChangeBikeState();
}

class _ChangeBikeState extends State<ChangeBike> {


  List<dynamic> _bikes=['Honda','Hero','BMW',"TVS","Bajaj","Yamaha","Royal Enfield","Suzuki","Piaggio","Mahindra","UM Lohia"];

  @override
  void initState() {
    if(widget.two.isNotEmpty){
      _bikes.clear();
      _bikes.addAll(widget.two);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: Text("Two wheeler"),
      ),
      backgroundColor: background,
      body: Container(
        child: GridView.count(crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children:List.generate(_bikes.length, (index){
            return InkWell(
              onTap: (){
                Navigator.pop(context,{'vehiclename':_bikes[index]});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: voilet,width: 2)
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.motorcycle,color: voilet,size: 50,),
                    Text(_bikes[index],style: GoogleFonts.lato(color: grey,fontWeight:FontWeight.w700),),
                  ],
                )
              ),
            );
          }),),
      ),
    );
  }
}
