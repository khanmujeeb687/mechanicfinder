
import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel_partner/Resources/Internet/check_network_connection.dart';
import 'package:forveel_partner/Resources/Internet/internetpopup.dart';
import 'package:forveel_partner/Resources/ui/GetPuncture.dart';
import 'package:forveel_partner/ui/Mycolors.dart';
import 'package:forveel_partner/ui/Start/completedetails/upload_video.dart';
import 'package:forveel_partner/ui/loader_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import 'addlocation.dart';


class CompleteDetails extends StatefulWidget {
  DocumentSnapshot data;
  CompleteDetails(this.data);
  @override
  _CompleteDetailsState createState() => _CompleteDetailsState();
}

class _CompleteDetailsState extends State<CompleteDetails> {
  Color btnbg=background;
  Color btntxt=blue;
  int pageindex;
  PageController _pageController=new PageController();

  String address;//address
  File adhar;//photo
  File photo;//photo
  String city;//address
  String desc;//additional
  DateTime dob=DateTime.now();//general
  String email;//general
  String exp;//addtional
  String lat;//address
  String long;//address
  String name;//general
  String shopname;//general
  List<bool> types=[false,false,false,false,false];//additional
  List<bool> vehicle_type=[false,false];//additional






  @override
  void initState() {
    pageindex=0;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: background,
        title: Text("Complete details",style: GoogleFonts.lato(color: grey),),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  ForveelOutlineButton(
                    text: "General info",
                    bg: pageindex==0?blue:background,
                    tx: pageindex==0?background:blue,
                    OnTap: (){
                      _pageController.animateToPage(0, duration: Duration(milliseconds: 50), curve: Curves.bounceInOut);
                    },
                  ),
                  ForveelOutlineButton(
                    text: "Additional details",
                    bg: pageindex==1?blue:background,
                    tx: pageindex==1?background:blue,
                    OnTap: (){
                      setState(() {
                        _pageController.animateToPage(1, duration: Duration(milliseconds: 50), curve: Curves.bounceInOut);

                      });
                    },
                  ),
                  ForveelOutlineButton(
                    text: "Photo",
                    bg: pageindex==2?blue:background,
                    tx: pageindex==2?background:blue,
                    OnTap: (){
                      setState(() {
                        _pageController.animateToPage(2, duration: Duration(milliseconds: 50), curve: Curves.bounceInOut);

                      });
                    },
                  ),
                  ForveelOutlineButton(
                    text: "Address",
                    bg: pageindex==3?blue:background,
                    tx: pageindex==3?background:blue,
                    OnTap: (){
                      setState(() {
                        _pageController.animateToPage(3, duration: Duration(milliseconds: 50), curve: Curves.bounceInOut);

                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height-200,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index){
                  setState(() {
                    pageindex=index;
                  });
                },
                children: <Widget>[
                  _generalinfo(),
                  _additional(),
                  _photo(),
                  _address()
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        child: Icon(Icons.arrow_forward,color: background,),
        onPressed: _submitform,
      ),
    );
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dob,
        initialDatePickerMode:DatePickerMode.year ,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked!=dob)
      setState(() {
        dob = picked;
      });
  }
  var _generalkey=GlobalKey<FormState>();
  Widget _generalinfo(){
    return Form(
      key: _generalkey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30,)
,          Text("General details",
            style: TextStyle(
                color: grey,
                letterSpacing: 2,
                fontSize: 30
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              keyboardType: TextInputType.text,
              initialValue: name!=null?name:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "name",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please enter your name";
                }
                else{
                  name=value;
                  return null;
                }
              },
              onChanged: (v){
                name=v;
              },
            ),
          ),

          SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              keyboardType: TextInputType.text,
              initialValue: shopname!=null?shopname:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "Shopname",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please enter your Shopname";
                }
                else{
                  shopname=value;
                  return null;
                }
              },
              onChanged: (v){
                shopname=v;
              },
            ),
          ),

          SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              keyboardType: TextInputType.emailAddress,
              initialValue: email!=null?email:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "Email",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){

                if(value.isEmpty)
                {
                  return "Please enter your Email";
                }
                else{
                  email=value;
                  return null;
                }
              },
              onChanged: (v){
                email=v;
              },
            ),
          ),SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new OutlineButton(
              padding: EdgeInsets.all(15),
              borderSide: BorderSide(color: grey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.calendar_today,color: blue,),
                  Text(dob.year==DateTime.now().year?"Select DOB":"DOB  ${dob.day}/${dob.month}/${dob.year}",
                  style: GoogleFonts.lato(
                    color: blue
                  ),
                  ),
                ],
              ),
              onPressed:(){
                _selectDate(context);
              },
            )
          ),

        ],
      ),
    );
  }


  var _additionalkey=GlobalKey<FormState>();

  Widget _additional(){
    return Form(
      key: _additionalkey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30,)
          ,          Text("Additional details",
            style: TextStyle(
                color: grey,
                letterSpacing: 2,
                fontSize: 30
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              maxLines: 5,
              keyboardType: TextInputType.text,
              initialValue: desc!=null?desc:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "Description",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please enter your description";
                }
                else{
                  desc=value;
                  return null;
                }
              },
              onChanged: (v){
                desc=v;
              },
            ),
          ),

          SizedBox(height: 10),
          Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: new TextFormField(
              style: TextStyle(
                  color: grey
              ),
              maxLength: 3,
              keyboardType: TextInputType.number,
              initialValue: exp!=null?exp:"",
              decoration: new InputDecoration(
                counterText: "",
                labelText: "Experience",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(5),
                ),
              ),
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty)
                {
                  return "Please enter your experience in years";
                }
                else{
                  exp=value;
                  return null;
                }
              },
              onChanged: (v){
                exp=v;
              },
            ),
          ),

          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey,width: 1),
                  borderRadius: BorderRadius.circular(5)
                ),
                width: MediaQuery.of(context).size.width/1.5,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AutoSizeText("Select vehicle",minFontSize: 18,maxFontSize:24,style: GoogleFonts.lato(color: voilet),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.motorcycle,color: grey,),
                        AutoSizeText("Two Wheelers",style: GoogleFonts.lato(color: grey),),
                        Checkbox(
                          value: vehicle_type[0],
                          onChanged: (v){
                            setState(() {
                              vehicle_type[0]=v;
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.directions_car,color: grey,),
                        AutoSizeText("Four Wheelers",
                          style: GoogleFonts.lato(color:grey),
                        ),
                        Checkbox(
                          value: vehicle_type[1],
                          onChanged: (v){
                            setState(() {
                              vehicle_type[1]=v;
                            });
                          },                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: grey,width: 1),
                    borderRadius: BorderRadius.circular(5)
                ),
                width: MediaQuery.of(context).size.width/1.5,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AutoSizeText("Select your skills",minFontSize: 18,maxFontSize:24,style: GoogleFonts.lato(color: voilet),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.motorcycle,color: grey,),
                        AutoSizeText("Mechanic",
                          style: GoogleFonts.lato(color:grey),
                        ),
                        Checkbox(
                          value: types[0],
                          onChanged: (v){
                            setState(() {
                              types[0]=v;
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.directions_car,color: grey,),
                        AutoSizeText("Electricial",
                          style: GoogleFonts.lato(color:grey),

                        ),
                        Checkbox(
                          value: types[1],
                          onChanged: (v){
                            setState(() {
                              types[1]=v;
                            });
                          },                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.directions_car,color: grey,),
                        AutoSizeText("Ac repair",
                          style: GoogleFonts.lato(color:grey),

                        ),
                        Checkbox(
                          value: types[2],
                          onChanged: (v){
                            setState(() {
                              types[2]=v;
                            });
                          },                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.directions_car,color: grey,),
                        AutoSizeText("Denter/painter",
                          style: GoogleFonts.lato(color:grey),

                        ),
                        Checkbox(
                          value: types[3],
                          onChanged: (v){
                            setState(() {
                              types[3]=v;
                            });
                          },                        )
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(Icons.directions_car,color: grey,),
                        AutoSizeText("vehicle scanning",
                          style: GoogleFonts.lato(color:grey),

                        ),
                        Checkbox(
                          value: types[4],
                          onChanged: (v){
                            setState(() {
                              types[4]=v;
                            });
                          },                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }

  Widget _photo(){
    return Container(
      alignment: Alignment.center,
      child: ListView(

        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: grey,width: 1)
            ),
            height: MediaQuery.of(context).size.height/2-50,
            margin: EdgeInsets.all(20),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select profile picture",
                style: GoogleFonts.lato(color:voilet,fontWeight: FontWeight.bold,fontSize: 20),
                ),
                Divider(height: 1,color: grey,thickness: 1,),
                Flexible(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){
                        _pickimage(true);
                      },
                      child: (){
                        if(photo!=null){
                          return Image.file(photo,
                            fit: BoxFit.cover,
                          );
                        }else{
                          return Icon(FontAwesomeIcons.userCircle,color: grey,size: 80,);
                        }
                      }(),
                    )
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: grey,width: 1)
            ),
            height: MediaQuery.of(context).size.height/2-50,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select Adharcard",
                  style: GoogleFonts.lato(color:voilet,fontWeight: FontWeight.bold,fontSize: 20),
                ),
                Divider(height: 1,color: grey,thickness: 1,),                Flexible(
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          _pickimage(false);
                        },
                        child: (){
                          if(adhar!=null){
                            return Image.file(adhar,
                              fit: BoxFit.cover,
                            );
                          }else{
                            return Icon(FontAwesomeIcons.passport,color: grey,size: 80,);
                          }
                        }(),
                      )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Completer<GoogleMapController> _controller = Completer();
  Widget _address(){
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: ()async{
            Map addressdata=await Navigator.push(context, PageTransition(
              child: AddLocation(),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 10)
            ));
            if(addressdata.isNotEmpty){
              setState(() {
                address=addressdata["address"];
                city=addressdata["city"];
                lat=addressdata["lat"];
                long=addressdata["long"];
              });

            }
          },
          child: Card(
            elevation: 13,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.location_on,color: blue,),
                      Text("Mark address",style: GoogleFonts.lato(color: grey,fontSize: 20),),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width-50,
                  height: MediaQuery.of(context).size.height/2,
                  alignment: Alignment.center,
                  child: Icon(Icons.map,color: green,size: 100,)
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.bottomCenter,
                  child: AutoSizeText(
                    (address==null?"":address),
                    minFontSize: 10,
                    maxFontSize: 20,
                    style: GoogleFonts.lato(color: grey),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


  _pickimage(bool value) async{
    if(value){
      File photo=await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 15);
      if(photo!=null){
        setState(() {
          this.photo=photo;
        });
      }
    }else{
      File photo=await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 15);
      if(photo!=null){
        setState(() {
          this.adhar=photo;
        });
      }
    }
}




  void _submitform() async{
    if(pageindex==0){
      if(name==null || name.isEmpty){
        Toast.show("Please enter your name!",
            context,textColor: Colors.red.shade700,backgroundColor: background,
            gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
      }
      else if(shopname==null || shopname.isEmpty){
        Toast.show("Please enter your shopname!",
            context,textColor: Colors.red.shade700,backgroundColor: background,
            gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
      }
      else if(email==null || email.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)
      ){
        Toast.show("Please enter your email address!",
            context,textColor: Colors.red.shade700,backgroundColor: background,
            gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
      }
      else if(dob.year==DateTime.now().year){
        Toast.show("Please select correct Date of birth!",
            context,textColor: Colors.red.shade700,backgroundColor: background,
            gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
      }else{
        _pageController.nextPage(duration: Duration(milliseconds: 10), curve:Curves.easeInCirc);
        return;
      }
    }


   else if(pageindex==1){
      if(desc==null || desc.isEmpty){
       Toast.show("Please enter your description!",
           context,textColor: Colors.red.shade700,backgroundColor: background,
           gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
     }
     else if(exp==null || exp.isEmpty){
       Toast.show("Please enter your experience in years!",
           context,textColor: Colors.red.shade700,backgroundColor: background,
           gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
     }
     else if(!vehicle_type.contains(true)){
       Toast.show("Please select your vehicle type!",
           context,textColor: Colors.red.shade700,backgroundColor: background,
           gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
     }
     else if(!types.contains(true)){
       Toast.show("Please select your skills!",
           context,textColor: Colors.red.shade700,backgroundColor: background,
           gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
     }
     else{
        _pageController.nextPage(duration: Duration(milliseconds: 10), curve:Curves.easeInCirc);
        return;
      }
     }
    else if(pageindex==2){
      if(adhar==null){
       Toast.show("Please select your adhar!",
           context,textColor: Colors.red.shade700,backgroundColor: background,
           gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
     }
     else if(photo==null){
       Toast.show("Please select your profile photo!",
           context,textColor: Colors.red.shade700,backgroundColor: background,
           gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
     }else{
        _pageController.nextPage(duration: Duration(milliseconds: 10), curve:Curves.easeInCirc);
        return;
      }
     }
     else if(pageindex==3){
     if(address==null || address.isEmpty){
      Toast.show("Please select your address!",
          context,textColor: Colors.red.shade700,backgroundColor: background,
          gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
    }
    else if(city==null || city.isEmpty || city=="null"){
      Toast.show("Please select your address!",
          context,textColor: Colors.red.shade700,backgroundColor: background,
          gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
    }
    else if(lat==null || lat.isEmpty){
      Toast.show("Please select your address!",
          context,textColor: Colors.red.shade700,backgroundColor: background,
          gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
    }
    else if(long==null || long.isEmpty){
      Toast.show("Please select your address!",
          context,textColor: Colors.red.shade700,backgroundColor: background,
          gravity: Toast.CENTER,duration: Toast.LENGTH_SHORT);
    }
    else{
      List<String> _type=[];
      List<String> _vtypes=[];
      if(vehicle_type[0]){_vtypes.add("tw");}
      if(vehicle_type[1]){_vtypes.add("fw");}
      if(types[0]){_type.add("mechanic");}
      if(types[1]){_type.add("electrician");}
      if(types[2]){_type.add("ac_repair");}
      if(types[3]){_type.add("denter/painter");}
      if(types[4]){_type.add("car_scanning");}
      if(await IsConnectedtoInternet()){
        ShowInternetDialog(context);
        return;
      }
       List<bool> _puncture = await showDialog(context: context,barrierDismissible: false,builder: (context){
         return GetPuncture();
       });
      _updatedata(_type,_vtypes,_puncture);
    }
    }

  }


  _updatedata(List<String> _type,List<String> _vtypes,List<bool> _puncture) async{
    bool sure=false;
     sure=await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return WillPopScope(
            onWillPop: (){
              Navigator.pop(context,false);
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              title: Text("Sumit details?",style: GoogleFonts.lato(color: grey),),
              actions: <Widget>[
                OutlineButton(
                  child: Text("Submit",style: GoogleFonts.lato(color: green),),
                  onPressed: (){
                    Navigator.pop(context,true);
                  },
                ),
                OutlineButton(
                  child: Text("Cancel",style: GoogleFonts.lato(color: voilet),),
                  onPressed: (){
                    Navigator.pop(context,false);
                  },
                ),
              ],
            ),
          );
        }

    );
     if(!sure){
       return;
     }

    Map waiter=await showDialog(context: context,barrierDismissible: false,builder: (context){
      return UploadVideo(photo,adhar);
    });
    if(waiter.isNotEmpty){
   String _adharlink=waiter["adhar"];
   String _photolink=waiter["photo"];
   LoaderDialog(context, false);
   Firestore.instance.collection('mechanic').document(widget.data.documentID).updateData({
     "name":name,
     "shopname":shopname,
     "address":address,
     "adhar":_adharlink,
     "city":city,
     "desc":desc,
     "dob":dob,
     "email":email,
     "exp":exp,
     "lat":lat,
     "long":long,
     "photo":_photolink,
     "types":_type,
     "vehicle_type":_vtypes,
     "datetime":DateTime.now().millisecondsSinceEpoch.toString(),
     "twowheelpuncture":_puncture[0],
     "threewheelpuncture":_puncture[1],
     "fourwheelpuncture":_puncture[2],
     "morewheelpuncture":_puncture[3],
   }).then((value){
     Navigator.pop(context);
     Navigator.pop(context);
   });
    }



  }
}


class ForveelOutlineButton extends StatefulWidget {
  Color bg;
  Color tx;
  String text;
  VoidCallback OnTap;
  ForveelOutlineButton({this.bg,this.text,this.OnTap,this.tx});
  @override
  _ForveelOutlineButtonState createState() => _ForveelOutlineButtonState();
}

class _ForveelOutlineButtonState extends State<ForveelOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 100,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.OnTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: blue),
              color: widget.bg
            ),
            child: Text(widget.text,style: GoogleFonts.lato(color: widget.tx),textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }
}

