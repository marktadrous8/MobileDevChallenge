import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String displayName;
  final String photoUrl;

  const HomePage({
    Key? key,
    required this.displayName,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $displayName!'),
            SizedBox(height: 20),
            Image.network(photoUrl),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/accessibility');
              },
              child: Text('Go to Accessibility Page'),
            ),
          ],
        ),
      ),
    );
  }
}