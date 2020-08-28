import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forveel/Resources/themes/light_color.dart';
import 'package:forveel/ui/Mycolors.dart';

class ForveelTile extends StatefulWidget {
  Widget leading;
  List<Widget> middle;
  VoidCallback ontap;
  ForveelTile({this.middle,this.leading,this.ontap});

  @override
  _ForveelTileState createState() => _ForveelTileState();
}

class _ForveelTileState extends State<ForveelTile> {
  @override
  void initState() {
    if(widget.leading==null){
      widget.leading=Container(width: 0,height: 0,);
    }

    if(widget.middle==null){
      widget.middle=[Container(width: 0,height: 0,)];
    }


    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        margin: EdgeInsets.fromLTRB(7, 3, 7, 0),
        decoration: BoxDecoration(
          color: LightColor.background,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.ontap,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        child: widget.leading),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.middle
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
