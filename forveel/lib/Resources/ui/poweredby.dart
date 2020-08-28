import 'package:flutter/material.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:google_fonts/google_fonts.dart';

class Poweredby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Powered by",style: GoogleFonts.lato(color: grey),),
            Text("Forveel",style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                letterSpacing: 2),),
          ],
        ),
      ),
    );
  }
}
