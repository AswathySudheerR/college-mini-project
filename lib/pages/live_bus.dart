import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveBusSearchPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  LiveBusSearchPage({required this.latitude, required this.longitude});

  @override
  _LiveBusSearchPageState createState() => _LiveBusSearchPageState();
}

class _LiveBusSearchPageState extends State<LiveBusSearchPage> {
  List<DocumentSnapshot> _nearestBusStops = [];
  List<DocumentSnapshot> _busesPassingThroughStops = [];

  @override
  void initState() {
    super.initState();
    getNearestBusStopsAndBuses(widget.latitude, widget.longitude);
  }

  Future<void> getNearestBusStopsAndBuses(double latitude, double longitude) async {
  
    _nearestBusStops = await retrieveNearestBusStops(latitude, longitude);
    _busesPassingThroughStops = await retrieveBusesPassingThroughStops(_nearestBusStops);
    setState(() {});
  }

  Future<List<DocumentSnapshot>> retrieveNearestBusStops(double latitude, double longitude) async {
    double radius = 10.0;
    double latOffset = 0.009 * radius;
    double lonOffset = 0.009 * radius;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Stops')
        .where('latitude', isGreaterThan: latitude - latOffset)
        .where('latitude', isLessThan: latitude + latOffset)
        .where('longitude', isGreaterThan: longitude - lonOffset)
        .where('longitude', isLessThan: longitude + lonOffset)
        .get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveBusesPassingThroughStops(List<DocumentSnapshot> busStops) async {
    List<DocumentSnapshot> busesPassingThroughStops = [];

    for (var busStop in busStops) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Buses')
          .where('stops', arrayContains: busStop.id)
          .get();

      busesPassingThroughStops.addAll(querySnapshot.docs);
    }

    return busesPassingThroughStops;
  }

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
            Text('Nearest Bus Stops:'),
            _nearestBusStops.isEmpty
                ? CircularProgressIndicator()
                : Column(
                    children: _nearestBusStops.map((busStop) {
                      return Text(busStop['name']);
                    }).toList(),
                  ),
            SizedBox(height: 20),
            Text('Buses Passing Through Nearest Bus Stops:'),
            _busesPassingThroughStops.isEmpty
                ? CircularProgressIndicator()
                : Column(
                    children: _busesPassingThroughStops.map((bus) {
                      return Text(bus['name']);
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
