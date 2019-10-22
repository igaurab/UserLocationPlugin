import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:user_location/src/user_location_options.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:user_location/utils/LocationListener.dart';

class MapsPluginLayer extends StatefulWidget {
  final UserLocationOptions options;
  final MapState map;
  final Stream<Null> stream;

  MapsPluginLayer(this.options, this.map, this.stream);

  @override
  _MapsPluginLayerState createState() => _MapsPluginLayerState();
}

class _MapsPluginLayerState extends State<MapsPluginLayer> {
  LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    _handleLocationChanges();
    _subscribeToLocationChanges();
  }

  void _subscribeToLocationChanges() {
    var location = Location();
    location.onLocationChanged().listen((onValue) {
      setState(() {
        if (onValue.latitude == null || onValue.longitude == null) {
          _currentLocation = LatLng(0, 0);
        } else {
          _currentLocation = LatLng(onValue.latitude, onValue.longitude);
          print(_currentLocation);
        }

        var height = 20.0 * (1 - (onValue.accuracy / 100));
        var width = 20.0 * (1 - (onValue.accuracy / 100));

        widget.options.markers.clear();
        widget.options.markers.add(Marker(
            point:
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
            builder: (context) {
              return Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[300].withOpacity(0.7)),
                  ),
                  widget.options.markerWidget ??
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blueAccent),
                      )
                ],
              );
            }));

        widget.options.mapController.move(
            LatLng(_currentLocation.latitude, _currentLocation.longitude),
            widget.map.zoom ?? 15);
      });
    });
  }
  void _handleLocationChanges() {
    LocationListener locationListener;
    locationListener.onLocationStatusChanged().listen((onData) {
      print("LOCATION STATUS: $onData");
    });

  }
  Widget build(BuildContext context) {
    return Container();
  }
}
