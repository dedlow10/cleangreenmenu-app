import 'package:cleangreenmenu/screens/restaurant_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool capturedCode = false;
  bool isTestMode = false;
  var testModeButton = Container();
  Animation<Alignment> _animation;
  AnimationController _animationController;
  QRCaptureController _captureController = QRCaptureController();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
  }

  @override
  void dispose() {
    capturedCode = false;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _captureController.onCapture((data) {
      if (capturedCode)
        return;
      else {
        capturedCode = true;
      }
      print('onCapture----$data');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => RestaurantScreen(data)))
          .then((value) {
        capturedCode = false;
      });
    });

    if (isTestMode) {
      testModeButton = Container(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          child: Text('Restaurant View (Test Mode)'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RestaurantScreen("4")));
          },
        ),
      ));
    }

    return Scaffold(
        body: Container(
            /*decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/home_background.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.3), BlendMode.dstATop),
              ),
            ),*/
            child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 250,
          height: 250,
          child: QRCaptureView(
            controller: _captureController,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 56),
          child: AspectRatio(
            aspectRatio: 264 / 258.0,
            child: Stack(
              alignment: _animation.value,
              children: <Widget>[
                Image.asset('images/sao@3x.png'),
                Image.asset('images/tiao@3x.png')
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Container(
              margin: new EdgeInsets.only(bottom: 400.0),
              width: 290.0,
              height: 120.0,
              child: Container(
                  margin: new EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: [
                        Text(
                          'WELCOME TO THE FUTURE OF MENUS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ]))),
              //child: _buildToolBar(),
            )),
        Align(
            alignment: Alignment.center,
            child: Container(
                margin: new EdgeInsets.only(top: 520.0),
                child: Column(children: [
                  Container(
                      width: 400,
                      child: Text(
                        'Scan restaurant code in box above',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                      )),
                  //child: _buildToolBar(),
                  Container(
                      alignment: Alignment.center,
                      width: 290,
                      child: Row(children: [
                        Text(
                          '(it looks something like this:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              image: new DecorationImage(
                                image: AssetImage("images/qrcode.png"),
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                        Text(
                          ')',
                          style: TextStyle(fontSize: 20),
                        ),
                      ])),
                  //child: _buildToolBar(),
                ]))),
        testModeButton
      ],
    )));
  }
}