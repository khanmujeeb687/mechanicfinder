import 'package:flutter/material.dart';
Color background=Colors.white;
Color textc=Colors.grey;
Color myappbar=Colors.redAccent;
Color myyellow=Color(hexStringToHexInt("#C8B4Ba"));
Color voilet = Color(hexStringToHexInt("#C8B4Ba"));
Color skin = Color(hexStringToHexInt("#F3DDB3"));
Color green = Color(hexStringToHexInt("#C1CD97"));
Color pink = Color(hexStringToHexInt("#E18D96"));
Color grey = Color(hexStringToHexInt("#909090"));
Color lime = Colors.lime[400];



int hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return val;
}