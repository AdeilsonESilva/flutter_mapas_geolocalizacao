import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(-22.931738, -47.076785),
    zoom: 17,
  );

  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete((googleMapController));
    print(_controller.isCompleted);
  }

  void _movimentarCamera() async {
    var googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
          // CameraPosition(
          //   target: LatLng(-22.939208, -47.064586),
          //   zoom: 16,
          //   tilt: 45, // Angulo
          //   bearing: 30, // Rotação
          // ),
          _posicaoCamera),
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

  void _carregarPolygons() {
    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
      polygonId: PolygonId('polygon1'),
      fillColor: Colors.green,
      // fillColor: Colors.transparent,
      strokeColor: Colors.red,
      strokeWidth: 10,
      points: [
        LatLng(-22.933545, -47.078211),
        LatLng(-22.930630, -47.078690),
        LatLng(-22.932893, -47.075750)
      ],
      consumeTapEvents: true,
      onTap: () {
        print('clicado!');
      },
      zIndex: 0,
    );

    Polygon polygon2 = Polygon(
      polygonId: PolygonId('polygon1'),
      fillColor: Colors.purple,
      // fillColor: Colors.transparent,
      strokeColor: Colors.orange,
      strokeWidth: 10,
      points: [
        LatLng(-22.931025, -47.075578),
        LatLng(-22.932359, -47.080395),
        LatLng(-22.933149, -47.079837),
      ],
      consumeTapEvents: true,
      onTap: () {
        print('clicado!');
      },
      zIndex: 1,
    );

    listaPolygons.add(polygon1);
    listaPolygons.add(polygon2);

    setState(() {
      _polygons = listaPolygons;
    });
  }

  void _carregarPolylines() {
    Set<Polyline> listaPolylines = {};

    Polyline polyline = Polyline(
      polylineId: PolylineId('polyline'),
      color: Colors.red,
      width: 40,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      points: [
        LatLng(-22.933545, -47.078211),
        LatLng(-22.930630, -47.078690),
        LatLng(-22.932893, -47.075750)
      ],
      consumeTapEvents: true,
      onTap: () {
        print('Clicado!!');
      },
    );

    listaPolylines.add(polyline);

    setState(() {
      _polylines = listaPolylines;
    });
  }

  void _recuperarLocalizacaoAtual() async {
    var posicao = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print(posicao);

    setState(() {
      _posicaoCamera = CameraPosition(
        target: LatLng(posicao.latitude, posicao.longitude),
        zoom: 17,
      );
      _movimentarCamera();
    });
  }

  void _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    geolocator.getPositionStream(locationOptions).listen((position) {
      // var marcadorUsuario = Marker(
      //   markerId: MarkerId('marcador-usuario'),
      //   position: LatLng(position.latitude, position.longitude),
      //   infoWindow: InfoWindow(
      //     title: 'Meu Local',
      //   ),
      //   icon: BitmapDescriptor.defaultMarkerWithHue(
      //     BitmapDescriptor.hueBlue,
      //   ),
      //   rotation: 45,
      //   onTap: () {
      //     print('Meu local clicado');
      //   },
      // );

      setState(() {
        // _marcadores.add(marcadorUsuario);
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17,
        );
        _movimentarCamera();
      });
    });
  }

  void _recuperarLocalParaEndereco() async {
    var listaEnderecos =
        await Geolocator().placemarkFromAddress('Campinas Shopping');

    if (listaEnderecos.length > 0) {
      var item = listaEnderecos[0];
      String resultado = "administrativeArea - ${item.administrativeArea}\n"
          "subAdministrativeArea - ${item.subAdministrativeArea}\n"
          "locality - ${item.locality}\n"
          "subLocality - ${item.subLocality}\n"
          "thoroughfare - ${item.thoroughfare}\n"
          "subThoroughfare - ${item.subThoroughfare}\n"
          "postalCode - ${item.postalCode}\n"
          "country - ${item.country}\n"
          "isoCountryCode - ${item.isoCountryCode}\n"
          "position - ${item.position}\n";

      print(resultado);
    }
  }

  void _recuperarLocalParaLatLong() async {
    var listaEnderecos =
        await Geolocator().placemarkFromCoordinates(-22.934858, -47.087944);

    if (listaEnderecos.length > 0) {
      var item = listaEnderecos[0];
      String resultado = "administrativeArea - ${item.administrativeArea}\n"
          "subAdministrativeArea - ${item.subAdministrativeArea}\n"
          "locality - ${item.locality}\n"
          "subLocality - ${item.subLocality}\n"
          "thoroughfare - ${item.thoroughfare}\n"
          "subThoroughfare - ${item.subThoroughfare}\n"
          "postalCode - ${item.postalCode}\n"
          "country - ${item.country}\n"
          "isoCountryCode - ${item.isoCountryCode}\n"
          "position - ${item.position}\n";

      print(resultado);
    }
  }

  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    // _carregarPolygons();
    // _carregarPolylines();
    // _recuperarLocalizacaoAtual();
    // _adicionarListenerLocalizacao();
    // _recuperarLocalParaEndereco();
    _recuperarLocalParaLatLong();
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
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          markers: _marcadores,
          polygons: _polygons,
          polylines: _polylines,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
