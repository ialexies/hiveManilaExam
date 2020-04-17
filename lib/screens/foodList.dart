import 'package:flutter/material.dart';


class FoodList extends StatefulWidget {
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text('food 1'),
          Text('food 2'),
          Text('food 3'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
         child: Icon(Icons.camera),
        onPressed: (){
          print('fdfd');
        }),
    );
  }
}