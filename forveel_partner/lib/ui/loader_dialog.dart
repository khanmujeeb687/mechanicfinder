import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Mycolors.dart';

LoaderDialog(context,dismiss) {
  showDialog(

      barrierDismissible: dismiss, context: context, builder: (context) {
    return WillPopScope(
// ignore: missing_return
      onWillPop: () {},
      child: AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            child: SpinKitThreeBounce(
              color: textc,
            ),
          )
      ),
    );
  });
}