import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geo_locator/distance.dart';
import 'package:geo_locator/model/location_model.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String lat = "";
  String lon = "";
  var _lat1;
  var _lon1;
  UsbPort? _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;
  String near_place = '';
  double? distance;

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port!.close();
      _port = null;
    }

    if (device == null) {
      _device = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }
    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port!.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction!.stream.listen(
      (String line) {
          if (line.contains("GPRMC")) {
            lat = "";
            lon = "";
            print(line);
            String lat1 = line.split(",")[3];
            for (var i = 0; i < lat1.length; i++) {
              if (i == 2) {
                lat += ".";
              }
              if (i != 4) {
                lat += lat1[i];
              }
            }
            String lon1 = line.split(",")[5];
            for (var i = 0; i < lon1.length; i++) {
              if (i != 0) {
                if (i == 3) {
                  lon += ".";
                }
                if (i != 5) {
                  lon += lon1[i];
                }
              }
            }

            _lat1 = double.parse(lat);
            _lon1 = double.parse(lon);

            var min_lat = (_lat1 % 1) / 0.6;
            var min_lon = (_lon1 % 1) / 0.6;

            _lat1 = _lat1.floorToDouble() + min_lat;
            _lon1 = _lon1.floorToDouble() + min_lon;

            for (LocationModel location in locationData) {
              // var _lat1 = 27.6879661;

              var _lat2 = double.parse(location.latitude);
              print(_lat1 + " " + _lon1);

              // var minuite1= (int)(((decimal)number % 1) * 100)
              // var _lon1 = 85.3299993;
              var _lon2 = double.parse(location.longitude);
              var _distance =
                  1000 * calculateDistance(_lat1, _lon1, _lat2, _lon2);
              if (_distance < location.radius) {
                setState(() {
                  distance = _distance;
                  near_place = location.name;
                });
                print(
                    "you are near ${location.name} with distance of $_distance meter");
              }
            }
            _serialData.add(Text(line));
          }

          if (_serialData.length > 20) {
            _serialData.removeAt(0);
          }
        setState(() {
        });
      },
    );

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty)
      _connectTo(devices.firstWhere((element) {
        print(element);
        return element.productName!.toLowerCase().contains("bridge");
      }));

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('USB Serial Plugin example app '),
      ),
      body: Center(
          child: Column(children: <Widget>[
        Text('Status: $_status\n'),
        // Text('info: ${_port.toString()}\n'),
        Text("You are Near"),
        Text("location: $near_place distance: $distance "),
       _lat1!=null&&_lon1!=null? Text("lat: ${_lat1.toStringAsFixed(6)} long = ${_lon1.toStringAsFixed(6)}"):Container(),
        Text("Result Data", style: Theme.of(context).textTheme.headline6),
        ..._serialData,
      ])),
    ));
  }
}
