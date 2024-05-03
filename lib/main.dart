import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'pages/search_remote_bus.dart';
import 'pages/live_bus.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBWBi45vP6dUJqtr_jGohZ2kAqevkFV-0s",
      appId: "1:725490501172:android:010e656270153123ab6c61",
      messagingSenderId: "725490501172",
      authDomain: "localhost",
      projectId: "bus-tracking-app-2b0da",
      // Add other configuration options as needed
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Search App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            elevation: 5.0,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              
              Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[200]!, Colors.blue[800]!, Colors.green[800]!], 
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.directions_bus,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Device location - Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    
    // Navigate to LiveBusSearchPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LiveBusSearchPage( latitude: position.latitude,
        longitude: position.longitude,)),
    );
  } else {
    print('Location permission denied.');
  }
},

                icon: Icon(Icons.search) ,
                label: Text(
                  'Search Live Buses',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500), // Transition duration
                      pageBuilder: (_, __, ___) => SearchPage(
                        //showSearchRemoteBus: showSearchRemoteBus,
                      ),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                icon: Icon(Icons.search),
                label: Text(
                  'Search Remote Buses',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  void showSearchRemoteBus() {
    String from = fromController.text;
    String to = toController.text;

    // Navigate to search results page with 'from' and 'to' parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(from: from, to: to),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Remote Buses'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[200]!, Colors.blue[800]!, Colors.green[800]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: fromController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'From',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: toController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'To',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: showSearchRemoteBus,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    'Search',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

