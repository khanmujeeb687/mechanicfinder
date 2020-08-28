import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forveel_partner/Resources/Internet/check_network_connection.dart';
import 'package:forveel_partner/Resources/Internet/internetpopup.dart';
import 'package:forveel_partner/ui/Widget/Home/cards/under_service_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';

import '../../Mycolors.dart';
import 'cards/history_card.dart';
import 'cards/request_card.dart';

class Requests extends StatefulWidget {
  List<DocumentSnapshot> data;
  Position position;
  List<bool> filters;
  Requests(this.data,this.position,this.filters);
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  @override
  Widget build(BuildContext context) {
    return  Container(

        child: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: background
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8,sigmaY: 8),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                  itemCount: widget.data.length,
                  itemBuilder: (context,index){

                    if(widget.data[index]['status']=="pending" && widget.filters[0]){
                      return RequestCard(widget.data[index],widget.position);
                    }else if((widget.data[index]['status'].contains('cancelled') || widget.data[index]['status']=="success") && widget.filters[2]){
                      return HistoryCard(widget.data[index]);
                    }
                    else if((widget.data[index]['status']=="accepted" ||
                        widget.data[index]['status']=="picked up" ||
                        widget.data[index]['status']=="repaired" || widget.data[index]['status']=="out for pickup") && widget.filters[1]){
                      return USCard(widget.data[index],widget.position);
                    }
                    return Container(height: 0,width: 0,);
                  }
              ),
            ),
          ),
        )

    );
  }





}
