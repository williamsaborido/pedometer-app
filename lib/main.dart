import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

import 'about.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  String _stepCountValue = '?';
  double _avgMeter = 0;
  double _avgFeet = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onData(int newValue) async {
    setState(() {
      _stepCountValue = "$newValue";
      _avgFeet = int.parse(_stepCountValue) * 2.69;
      _avgMeter = int.parse(_stepCountValue) * 0.82;
    });
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: MyHome(_stepCountValue, _avgMeter, _avgFeet),
    );
  }
}

class MyHome extends StatelessWidget{
  String _stepCountValue;
  double _avgMeter;
  double _avgFeet;

  MyHome(this._stepCountValue, this._avgMeter, this._avgFeet);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer example app'),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
              },
            ),
          ],
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.directions_walk,
                  size: 90,
                ),
                new Text(
                  'Steps taken:',
                  style: TextStyle(fontSize: 30),
                ),
                new Text(
                  '$_stepCountValue',
                  style: TextStyle(fontSize: 100, color: Colors.blue),
                ),
                Text('Avg distance: ${_avgMeter.toStringAsFixed(2)} mt. (${_avgFeet.toStringAsFixed(2)} ft.)',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
        ),
    );
  }
}