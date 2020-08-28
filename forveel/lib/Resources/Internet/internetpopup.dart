import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/ui/Mycolors.dart';

void ShowInternetDialog(context){
  showDialog(context: context,
  builder: (context){
    return AlertDialog(
      actions: <Widget>[
        RaisedButton(
          elevation: 0,
          color: background,
          child: Text("Ok"),
          onPressed: ()=>Navigator.pop(context),
        )
      ],
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      title: Text("No internet connection!"),
      content: Container(height: 100,
        color: background,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error_outline,size: 30,color: Colors.red,),
            Text("Please connect to internet and try again" ,style: TextStyle(
              color: textc,
              fontSize: 20,
              fontWeight: FontWeight.w400
            ),)
          ],
        ),
      ),
    );
  }
  );
}