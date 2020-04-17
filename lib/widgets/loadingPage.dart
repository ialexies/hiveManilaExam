import 'package:flutter/material.dart';


class Lodingpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
               strokeWidth: 10,
              ),
            ),
            SizedBox(height: 20,),
            Text("Loading"),
          ],
        ),
      ),
    );
  }
}