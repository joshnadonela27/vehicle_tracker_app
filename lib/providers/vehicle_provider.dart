import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/vehicle.dart';

class VehicleProvider with ChangeNotifier {
  Vehicle _vehicle = Vehicle(
    id: '1',
    name: 'Vehicle #101',
    latitude: 17.3850,
    longitude: 78.4867,
  );

  final List<LatLng> _routeHistory = [const LatLng(17.3850, 78.4867)];
  WebSocketChannel? _channel;

  Vehicle get vehicle => _vehicle;
  List<LatLng> get routeHistory => List.unmodifiable(_routeHistory);

  void connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws/vehicle'),
    );

    _channel!.stream.listen((data) {
      final jsonData = jsonDecode(data);
      final double lat = jsonData['latitude'];
      final double lng = jsonData['longitude'];

      _vehicle = Vehicle(
        id: _vehicle.id,
        name: _vehicle.name,
        latitude: lat,
        longitude: lng,
      );

      _routeHistory.add(LatLng(lat, lng));
      notifyListeners();
    }, onError: (error) {
      print('WebSocket Error: $error');
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}