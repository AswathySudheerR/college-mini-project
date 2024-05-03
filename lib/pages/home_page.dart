import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _busIDController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _busNoController = TextEditingController();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _routesController = TextEditingController();

  @override
  void dispose() {
    _busIDController.dispose();
    _availabilityController.dispose();
    _busNoController.dispose();
    _busNameController.dispose();
    _routesController.dispose();
    super.dispose();
  }

  void updateBusInfo() {
    var busID = _busIDController.text.trim();
    var isAvailable = _availabilityController.text.trim().toLowerCase() == 'yes';
    //var busNo = _busNoController.text.trim();
    //var busName = _busNameController.text.trim();
    //var routes = _routesController.text.trim();

    FirebaseFirestore.instance.collection('buses').doc(busID).update({
      'isAvailable': isAvailable,
      //'busNo': busNo,
      //'busName': busName,
      //'routes': routes,
    }).then((value) {
      print("Bus Info Updated");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bus info updated successfully!")),
      );
    }).catchError((error) {
      print("Failed to update bus info: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update bus info")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Signed in as: ${user?.email ?? "No email available"}'),
              TextField(
                controller: _busIDController,
                decoration: InputDecoration(labelText: 'Bus ID'),
              ),
              TextField(
                controller: _availabilityController,
                decoration: InputDecoration(labelText: 'Available (Yes/No)'),
              ),
              //TextField(
                //controller: _busNoController,
                //decoration: InputDecoration(labelText: 'Bus Number'),
              //),
              //TextField(
                //controller: _busNameController,
                //decoration: InputDecoration(labelText: 'Bus Name'),
              //),
              //TextField(
                //controller: _routesController,
                //decoration: InputDecoration(labelText: 'Routes'),
              //),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateBusInfo,
                child: Text('Update Bus Info'),
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                color: Colors.purple,
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
