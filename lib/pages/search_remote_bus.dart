import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchResultsPage extends StatelessWidget {
  final String from;
  final String to;

  SearchResultsPage({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Search Results for:'),
            Text('From: $from'),
            Text('To: $to'),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Buses')
                    .where('from', isEqualTo: from)
                    .where('to', isEqualTo: to)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Text('No results found');
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                       String busName = data['busName'] ?? 'Unknown';
                       String departure = data['departure'] ?? 'Unknown';
                       String arrival = data['arrival'] ?? 'Unknown';
                      return ListTile(
                        title: Text(busName),
                        subtitle: Text('Departure: $departure - Arrival: $arrival'),
                        // You can display more details here
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//return ListView(
  //  children: snapshot.data!.docs.map((DocumentSnapshot document) {
  //    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //    String busName = data['busName'] ?? 'Unknown'; // Using ?? operator to provide a default value
  //    String departure = data['departure'] ?? 'Unknown';
  //   String arrival = data['arrival'] ?? 'Unknown';
  //    return ListTile(
  //      title: Text(busName),
  //      subtitle: Text('Departure: $departure - Arrival: $arrival'),
        // You can display more details here
  //    );
  //  }).toList(),
  //);
//},


