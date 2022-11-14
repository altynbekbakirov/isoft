import 'package:flutter/material.dart';
import 'package:isoft/routes/router_generator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 24,
            ),
            Text("Data loading... Please wait"),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              child: LinearProgressIndicator(),
              width: 200,
            ),
            const SizedBox(
              height: 12,
            ),
            Text('Product list downloading'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future _navigateToHome() async {
    await Future.delayed(
      Duration(seconds: 30),
    );
    Navigator.of(context).pushReplacementNamed(Routers.home);
  }
}
