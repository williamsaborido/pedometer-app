import 'dart:async';
import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'device_battery.dart';
import 'device_info.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  DeviceBattery battery = DeviceBattery();
  Map<String, dynamic> _deviceInfo = <String, dynamic>{};

  int _batteryLevel;
  String _batteryState;

  @override
  void initState() {
    super.initState();

    battery.onUpdate(() {
      setState(() {});
    });

    DeviceInfo().deviceInfo.then((result) {
      _deviceInfo = result;
      setState(() {});
    });
  }

  @override
  void setState(fn) async {
    super.setState(fn);

    _batteryLevel = battery.level;
    _batteryState = battery.state;
  }

  @override
  void dispose() {
    battery.Dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About device'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: _getDeviceData(),
        ),
      ),
    );
  }

  Icon _batteryStatusIcon() {

    if (_batteryState == 'Charged')
      return Icon(Icons.battery_full, color: Colors.blue);
    if (_batteryState == 'In use / discharging')
      return Icon(Icons.battery_full, color: Colors.blue);
    if (_batteryState == 'Charging')
      return Icon(Icons.battery_charging_full, color: Colors.blue);

    return Icon(Icons.battery_unknown, color: Colors.blue);
  }

  List<ListTile> _getDeviceData() {
    List<ListTile> result = List<ListTile>();

    result.add(
      ListTile(
        leading: Icon(
          Icons.battery_full,
          color: Colors.blue,
        ),
        title: Text('Battery level'),
        subtitle: Text(_batteryLevel == null
            ? 'Unknown / not supported'
            : '$_batteryLevel%'),
      ),
    );

    result.add(ListTile(
      leading: _batteryStatusIcon(),
      title: Text('Battery status'),
      subtitle: Text('$_batteryState'),
    ));

    _deviceInfo.forEach((key, value) {
      result.add(ListTile(
        leading: Icon(Icons.perm_device_information, color: Colors.teal),
        title: Text(key),
        subtitle: Text(value.toString()),
      ));
    });

    return result;
  }
}
