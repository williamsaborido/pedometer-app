import 'dart:async';

import 'package:battery/battery.dart';

class DeviceBattery{

  static DeviceBattery _instance;
  static Battery _battery;

  BatteryState _batteryState;
  StreamSubscription<BatteryState> _batterySubscription;

  int _level;
  String _state;

  factory DeviceBattery(){

    if (_battery == null){
      _battery = Battery();
    }
    _instance = DeviceBattery._();

    return _instance;
  }

  DeviceBattery._();

  int get level => _level;

  String get state{
   switch(_batteryState){
     case BatteryState.full:
       return 'Charged';
       break;
     case BatteryState.discharging:
       return 'In use / discharging';
       break;
     case BatteryState.charging:
       return 'Charging';
       break;
     default:
       return 'Unknown';
       break;
   }
  }

  void onUpdate(Function fn){
    _batterySubscription = _battery.onBatteryStateChanged.listen((BatteryState state) async {
      _level = await _battery.batteryLevel;
      _batteryState = state;
      if (fn != null) {
        fn();
      }
    });
  }

  void cancelSubscription(){
    _batterySubscription.cancel();
  }

  void Dispose(){

    cancelSubscription();

    _battery = null;
  }

}