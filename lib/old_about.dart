import 'dart:async';
import 'package:battery/battery.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  Battery _battery = Battery(); //object
  BatteryState _batteryState; //enum
  StreamSubscription<BatteryState> _batterySubscription;

  String _batteryLevel;
  String _batteryMode;

  int num = 0;

  @override
  void initState() {

    super.initState();

    _batterySubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {

        _batteryState = state;

        print('tick ${++num}');
      });
    });
  }

  @override
  void setState(fn) async {

    super.setState(fn);

    _batteryLevel = (await _battery.batteryLevel).toString();

    switch(_batteryState) {
      case BatteryState.charging:
        _batteryMode = "Carregando";
        break;
      case BatteryState.discharging:
        _batteryMode = "Em uso/descarregando";
        break;
      case BatteryState.full:
        _batteryMode = "Carregada";
        break;
      default:
        _batteryMode = "Idle";
    }
  }

  @override
  void dispose() {

    if (_batterySubscription != null) {
      _batterySubscription.cancel();
      print('disposed');

      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Battery Level: $_batteryLevel %')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Current state: $_batteryMode'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Update info'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () => setState((){}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}