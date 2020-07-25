import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};

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

  void _carregarMarcadores() {
    Set<Marker> marcadoresLocal = {};

    var marcadorShopping = Marker(
      markerId: MarkerId('marcador-shopping'),
      position: LatLng(-22.931738, -47.076785),
      infoWindow: InfoWindow(
        title: 'Campinas Shopping',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      rotation: 45,
      onTap: () {
        print('Shopping clicado');
      },
    );

    var marcadorCorreios = Marker(
      markerId: MarkerId('marcador-correios'),
      position: LatLng(-22.931175, -47.079596),
      infoWindow: InfoWindow(
        title: 'Correios - CEE Campinas',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueYellow,
      ),
    );

    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorCorreios);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
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
            target: LatLng(-22.931738, -47.076785),
            zoom: 16,
          ),
          onMapCreated: _onMapCreated,
          markers: _marcadores,
        ),
      ),
    );
  }
}
