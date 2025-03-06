import 'package:flutter/material.dart';

void startShowing(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED7902)),
          strokeWidth: 5 ,
          backgroundColor: Colors.white.withOpacity(0.3),
        ),
      );
    },
  );
}

void stopShowing(BuildContext context){

  Navigator.of(context, rootNavigator: true).pop();

}