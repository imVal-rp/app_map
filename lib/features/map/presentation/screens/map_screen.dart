import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Future<LatLng> _currentLocationFuture;
  static const LatLng _fallbackLocation = LatLng(17.8066, -97.7788);

  @override
  void initState() {
    super.initState();
    _currentLocationFuture = _determinePosition();
  }

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _fallbackLocation;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _fallbackLocation;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _fallbackLocation;
    }

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LatLng>(
        future: _currentLocationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          final LatLng center = snapshot.data ?? _fallbackLocation;

          return FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 15.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app_map',
              ),
            ],
          );
        },
      ),
    );
  }
}