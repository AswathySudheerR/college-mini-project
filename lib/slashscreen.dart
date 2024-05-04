import 'package:bus_track/main.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    gotomainpage(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ShimmerImg(),
      ),
    );
  }
}

Future<void> gotomainpage(context) async {
  await Future.delayed(Duration(seconds: 3));
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (ctx) => MyHomePage()));
}
class ShimmerImg extends StatelessWidget {
  const ShimmerImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          child: Shimmer.fromColors(
              child: Image.asset('lib/images/ic_launcher.png'),
              baseColor: Colors.green,
              highlightColor: Colors.blue),
        ),
      ),
    );
  }
}