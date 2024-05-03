import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveBusSearchPage extends StatelessWidget {
  final double latitude;
  final double longitude;

  LiveBusSearchPage({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Bus Search Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Live Bus Search Results'),
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude'),
            FutureBuilder(
              future: fetchBuses(latitude, longitude),
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data!.isEmpty) {
                    return Text('No buses found near your location.');
                  } else {
                    return Column(
                      children: snapshot.data!.map((bus) {
                        return Text(bus);
                      }).toList(),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> fetchBuses(double latitude, double longitude) async {
    // Define a radius for the search (in kilometers)
    double radius = 10.0; // Adjust this value as needed

    // Query Firestore for buses within the specified radius of the provided latitude and longitude
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('buses')
        .where('latitude', isGreaterThan: latitude - (0.009 * radius))
        .where('latitude', isLessThan: latitude + (0.009 * radius))
        .where('longitude', isGreaterThan: longitude - (0.009 * radius))
        .where('longitude', isLessThan: longitude + (0.009 * radius))
        .get();

    // Extract bus information from the query results
    List<String> buses = [];
    querySnapshot.docs.forEach((doc) {
      buses.add(doc['busName']);
    });

    return buses;
  }
}
