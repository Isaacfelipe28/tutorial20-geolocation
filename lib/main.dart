import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_device_compass/flutter_device_compass.dart';

import 'package:flutter/material.dart';
import 'models/waypoint.dart';
import 'widgets/compass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kGPS-Locator-Isaac Felipe',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dados fictícios para a Gaveta 2.
  double? latitude; 
  double? longitude;
  double? altitude;
  double heading = 0.0;

  String gpsStatus = "Aguardando GPS...";
  String compassStatus = "Aguardando bússola...";

  StreamSubscription<Position>? gpsSubscripition;
  StreamSubscription<CompassEvent>? compassSubscripition;

  Waypoint? navegandoPara;

  final List<Waypoint> waypoints = [
    const Waypoint(
      nome: 'WP001',
      latitude: -23.164281,
      longitude: -45.896756,
    ),
    const Waypoint(
      nome: 'WP002',
      latitude: -23.189425,
      longitude: -46.026272,
    ),
    const Waypoint(
      nome: 'WP003',
      latitude: -23.811881,
      longitude: -45.396372,
    ),
  ];

  void navegarPara(Waypoint waypoint) {
    print('Voce acionou o Navegar para ${waypoint.nome}');

    setState(() {
      navegandoPara = waypoint;
    });
  }

  void pararNavegacao() {
    if (navegandoPara != null) {
      print('Voce parou o Navegar para ${navegandoPara!.nome}');
    }

    setState(() {
      navegandoPara = null;
    });
  }

  void adicionarWaypoint() {
    print('Voce clicou no botão Add Waypoint');
  }

  void excluirWaypoint(Waypoint waypoint) {
    print('Voce acionou o excluir Waypoint ${waypoint.nome}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('kGPS-Locator')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Compass(heading: heading),

            const SizedBox(height: 8),

            Text(
              'Heading: ${heading.toStringAsFixed(1)}°',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildLocationInfo(),

            const SizedBox(height: 12),

            if (navegandoPara != null) _buildNavigationInfo(),

            const SizedBox(height: 8),

            Expanded(child: _buildWaypointList()),
          ],
        ), // Column
      ), // SafeArea

      floatingActionButton: navegandoPara != null
          ? FloatingActionButton.extended(
              onPressed: pararNavegacao,
              icon: const Icon(Icons.stop),
              label: const Text('STOP'),
            ) // FloatingActionButton.extended
          : null,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton.icon(
          onPressed: adicionarWaypoint,
          icon: const Icon(Icons.add_location_alt),
          label: const Text('Add Waypoint'),
        ), // FilledButton.icon
      ), // Padding
    ); // Scaffold
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _infoRow(
                'Latitude',
                '${latitude.toStringAsFixed(6)}°',
              ),
              _infoRow(
                'Longitude',
                '${longitude.toStringAsFixed(6)}°',
              ),
              _infoRow(
                'Altitude',
                '${altitude.toStringAsFixed(1)} m',
              ),
            ],
          ), // Column
        ), // Padding
      ), // Card
    ); // Padding
  }

  Widget _buildNavigationInfo() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'NAVEGANDO PARA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Text

            const SizedBox(height: 4),

            Text(
              navegandoPara!.nome,
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 4),

            const Text('Azimute: --°   Distância: -- m'),
          ],
        ), // Column
      ), // Padding
    ); // Card
  }

  Widget _buildWaypointList() {
    return ListView.builder(
      itemCount: waypoints.length,
      itemBuilder: (context, index) {
        final waypoint = waypoints[index];

        return Dismissible(
          key: ValueKey(waypoint.nome),
          direction: DismissDirection.endToStart,

          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, size: 30),
          ), // Container

          onDismissed: (_) {
            excluirWaypoint(waypoint);
          },

          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(waypoint.nome),
            subtitle: Text(
              '${waypoint.latitude.toStringAsFixed(6)}, '
              '${waypoint.longitude.toStringAsFixed(6)}',
            ), // Text

            onLongPress: () {
              navegarPara(waypoint);
            },
          ), // ListTile
        ); // Dismissible
      },
    ); // ListView.builder
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ), // Row
    ); // Padding
  }
}