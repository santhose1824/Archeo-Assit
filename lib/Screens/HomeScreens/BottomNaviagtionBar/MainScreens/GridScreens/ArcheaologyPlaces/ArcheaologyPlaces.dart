import 'package:archeoassist/Database/DatabaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArcheaologyPlaces extends StatefulWidget {
  const ArcheaologyPlaces({Key? key}) : super(key: key);

  @override
  State<ArcheaologyPlaces> createState() => _ArcheaologyPlacesState();
}

class _ArcheaologyPlacesState extends State<ArcheaologyPlaces> {
  GoogleMapController? mapController;
  Set<Marker> markers = Set();
  List<Map<String, dynamic>> mapLocations = [];
  late Marker tappedMarker =
      Marker(markerId: MarkerId('empty'), position: LatLng(0, 0));
  late int tappedMarkerIndex = -1; // Initialize with -1

  @override
  void initState() {
    super.initState();
    _loadMapLocations();
  }

  void _loadMapLocations() async {
    // Load map locations from Firebase or any other source
    List<Map<String, dynamic>>? locations =
        await DatabaseFunctions().getMapLocations();

    if (locations != null) {
      setState(() {
        mapLocations = locations;
        _addMarkers();
      });
    }
  }

  void _addMarkers() {
  print('Adding markers: $mapLocations');
  // Add markers for all locations
  for (int i = 0; i < mapLocations.length; i++) {
    // Convert string coordinates to double
    double lat = double.tryParse(mapLocations[i]['lat']) ?? 0.0;
    double long = double.tryParse(mapLocations[i]['long']) ?? 0.0;

    markers.add(
      Marker(
        markerId: MarkerId('marker_$i'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: mapLocations[i]['placeName'], // Use placeName instead of default 'Location $i'
          snippet: mapLocations[i]['details'],
        ),
        onTap: () {
          setState(() {
            tappedMarkerIndex = i; // Store the index
            tappedMarker = Marker(
              markerId: MarkerId('marker_$i'),
              position: LatLng(lat, long),
              infoWindow: InfoWindow(
                title: mapLocations[i]['placeName'], // Use placeName
                snippet: mapLocations[i]['details'],
              ),
            );
          });

          // Call the method to show details here
          _showDetailsDialog(
            tappedMarker.infoWindow.title!,
            tappedMarker.infoWindow.snippet!,
            mapLocations[tappedMarkerIndex]['year'],
          );
        },
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          onMapCreated: (controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(11.1271, 78.6569), // Centered around Tamil Nadu
            zoom: 7.0, // Adjust the zoom level as needed
          ),
          markers: markers,
          onTap: (LatLng latLng) {
            setState(() {
              tappedMarker =
                  Marker(markerId: MarkerId('empty'), position: latLng);
            });
          },
        ),
      ),
    );
  }

  Future<void> _showDetailsDialog(
    String title, String snippet, String year) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Place: $title'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Year: $year'),
            SizedBox(height: 8),
            Text('Details:'),
            Text(snippet),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
}