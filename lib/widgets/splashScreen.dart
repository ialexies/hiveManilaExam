import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class SplashScreen extends StatefulWidget {
  // SplashScreen({ Key key, this.duration }) : super(key: key);

  String title;
  String description;
  Widget content;
  Widget image;

  SplashScreen({this.title, this.description, this.content, this.image});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 3),
    );
    _controller.forward();

    _controller.addListener(() {
      setState(() {});
      // print(_controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // color: Colors.red.withOpacity(_controller.value),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.image == null ? SizedBox.shrink() : widget.image,
                Text(widget.title.toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(_controller.value)
                    )),
                SizedBox(height: 15),
                Text(widget.description.toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 30,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.black.withOpacity(_controller.value),
                    )),
                widget.content != null ? widget.content : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
