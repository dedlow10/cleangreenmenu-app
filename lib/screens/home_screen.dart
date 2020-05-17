import 'package:cleangreenmenu/screens/restaurant_screen.dart';
import 'package:cleangreenmenu/screens/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool capturedCode = false;
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

  qrView() {
    return Stack(alignment: Alignment.center, children: <Widget>[
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
      )
    ]);
  }

  heading() {
    return Container(
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                'WELCOME TO THE FUTURE OF MENUS',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24.0,
                    color: TextColor,
                    fontWeight: FontWeight.bold),
              ),
            ])));
  }

  textDisclaimer() {
    return Column(children: [
      Container(
          width: 400,
          child: Text(
            'Scan restaurant code in box above',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          )),
      //child: _buildToolBar(),
      Container(
          alignment: Alignment.center,
          width: 290,
          child: Wrap(children: [
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
    ]);
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

    return Scaffold(
        body: DefaultTextStyle(
            style: TextStyle(inherit: true, color: TextColor),
            child: Container(
                child: Column(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 350.0, height: 120.0, child: heading())),
                qrView(),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: new EdgeInsets.only(top: 20.0),
                        child: textDisclaimer())),
                Expanded(child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: FlatButton(
                        color: Color.fromRGBO(234, 234, 235, 100),
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));
                        },
                        child: Row(children: <Widget>[
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Text("Find a restaurant",
                              style: TextStyle(
                                  color: SecondaryTextColor, fontSize: 20))
                        ]))))
              ],
            ))));
  }
}
