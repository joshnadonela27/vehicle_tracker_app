import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VehicleProvider>(context, listen: false);
      provider.connectToWebSocket();
      
      // Listen to coordinate updates and move the map camera
      provider.addListener(() {
        if (mounted) {
          final pos = LatLng(provider.vehicle.latitude, provider.vehicle.longitude);
          _mapController.move(pos, _mapController.camera.zoom);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final vehicle = vehicleProvider.vehicle;
    final routePoints = vehicleProvider.routeHistory;
    final currentPos = LatLng(vehicle.latitude, vehicle.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Tracker: ${vehicle.name}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: currentPos,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.vehicle_tracker_app',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentPos,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.directions_car,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}