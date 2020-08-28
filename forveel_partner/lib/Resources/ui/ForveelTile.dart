import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForveelTile extends StatefulWidget {
  Widget leading;
  Widget trailing;
  List<Widget> middle;
  VoidCallback ontap;
  ForveelTile({this.trailing,this.middle,this.leading,this.ontap});

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
    if(widget.trailing==null){
      widget.trailing=Container(width: 0,height: 0,);
    }

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.trailing,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
