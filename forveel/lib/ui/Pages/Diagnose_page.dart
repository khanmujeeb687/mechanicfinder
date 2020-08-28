import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/DiagnoseResult.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';


var myindex;
var mywidth;
var myheight;
int myprevious;
List<String> quesans=List();
List<int> answers;
List<Widget> cardlist;


class DiagnosePage extends StatefulWidget {
  @override
  _DiagnosePageState createState() => _DiagnosePageState();
}

class _DiagnosePageState extends State<DiagnosePage> {

  @override
  void initState() {
    answers=[0,0,0,0,0,0,0,0,0];
    addques();
     cardlist=[
      commoncard(0),
      commoncard(1),
      commoncard(2),
      commoncard(3),
      commoncard(4),
      commoncard(5),
      commoncard(6),
      commoncard(7),
      commoncard(8),
      Submitbuttoncard()
    ];

    myindex=0;
    mywidth=300.00;
    myheight=350.00;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  elevation: 0,
  backgroundColor: voilet,
  title: Text("Diagnose issue",style: TextStyle(color: background),),
),
      backgroundColor: voilet,
      body: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [voilet,skin,green,pink,grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: ListView(
          children:cardlist
        ),
      ),
    );
  }





  void addques()
  {
    quesans.add("Engine Starting very late?",);
    quesans.add("Mobil Leakage?");
    quesans.add("White smoke from silencer?");
    quesans.add("Black smoke from silencer?");
    quesans.add("Bush Tearing?");
    quesans.add("Engine heating up?");
    quesans.add("Pickup very low?");
    quesans.add("gear stucking?");
    quesans.add("Tyres wearing out?");

  }



}




class commoncard extends StatefulWidget {
  int position;
  commoncard(this.position);
  @override
  _commoncardState createState() => _commoncardState();
}

class _commoncardState extends State<commoncard> {
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: answers[widget.position]==0?background.withOpacity(0.4):background,

      ),
      margin: EdgeInsets.only(top: 6),
      child: ListTile(
        leading: Icon(FontAwesomeIcons.question,color: pink,),
        title: Text(quesans[widget.position],style: TextStyle(color: grey),),
        onTap: (){
          if(answers[widget.position]==1){
            setState(() {
              answers[widget.position]=0;
            });
          }
          else{
            setState(() {
              answers[widget.position]=1;
            });
          }
        },
      )
    );
  }
}

class Submitbuttoncard extends StatefulWidget {
  @override
  _SubmitbuttoncardState createState() => _SubmitbuttoncardState();
}

class _SubmitbuttoncardState extends State<Submitbuttoncard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: green,
          ),
          margin: EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(FontAwesomeIcons.gofore,color: background,),
              Text("Submit",style: TextStyle(color: background),),
            ],

          )
      ),
      onTap: (){
        if(!answers.contains(1)){
          Toast.show("Please select an issue!",context,gravity: Toast.CENTER);
          Vibration.vibrate(duration: 100);
        }
        else{
          Navigator.push(context, PageTransition(
            child: DiagnoseResult(answers),
            type: PageTransitionType.scale,
            alignment: Alignment.bottomCenter,
            duration: Duration(milliseconds: 200)
          ));
        }
      },
    );
  }
}
