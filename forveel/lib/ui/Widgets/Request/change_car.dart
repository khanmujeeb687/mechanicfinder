import 'package:flutter/material.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:google_fonts/google_fonts.dart';


class ChangeCar extends StatefulWidget {
  List<dynamic> four;
  ChangeCar(this.four);
  @override
  _ChangeCarState createState() => _ChangeCarState();
}

class _ChangeCarState extends State<ChangeCar> {
  List<dynamic> _car=['Maruti Suzuki','Toyota','Hyundai',"Tata","Jeep","Ford",
    "MG Motor","Honda","Mahindra","Kia","Volkswagen","Renault","BMW","Mercedes Benz","Datsun","Volvo","Fiat","Audi"
    ,"Skoda","Mitsubishi","Nissan","jaguar","Lamborghini","Rolls Royce","Mini","Bugati","Aston Martin","Land Rover","Bentley",
    "Force Motor","Tesla","Porche","Ferrari","Maserati","ISUZU","Bajaj","DC","Premier","Haval","Lexus","Chevrolet","Citroen"];
  @override
  void initState() {
    if(widget.four.isNotEmpty){
      _car.clear();
      _car.addAll(widget.four);
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
        title: Text("Four wheeler"),

      ),
      backgroundColor: background,
      body: Container(
        child: GridView.count(crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        children:List.generate(_car.length, (index){
          return InkWell(
            onTap: (){
              Navigator.pop(context,{'vehiclename':_car[index].toString()});
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: voilet,width: 2)
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.directions_car,color: voilet,size: 50,),
                    Text(_car[index],style: GoogleFonts.lato(color: grey,fontWeight:FontWeight.w700),),
                  ],
                )
            ),
          );
        }),),
      ),
    );
  }
}
