import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete((googleMapController));
    print(_controller.isCompleted);
  }

  void _movimentarCamera() async {
    var googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-22.939208, -47.064586),
          zoom: 16,
          tilt: 45, // Angulo
          bearing: 30, // Rotação
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapas e geolocalização'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _movimentarCamera,
        child: Icon(Icons.done),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          // mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: LatLng(-22.923923, -47.090914),
            zoom: 16,
          ),
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }
}
