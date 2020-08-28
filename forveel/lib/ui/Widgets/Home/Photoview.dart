import 'package:cached_network_image/cached_network_image.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';


class Photoviewer extends StatefulWidget {
  String url;
  Photoviewer({this.url});
  @override
  _PhotoviewerState createState() => _PhotoviewerState();
}

class _PhotoviewerState extends State<Photoviewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile photo",style: GoogleFonts.lato(color: background),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.center,
        child: PhotoView(
          imageProvider: NetworkImage(widget.url),
        ),
      ),
    );
  }
}
