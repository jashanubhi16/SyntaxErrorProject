import 'package:auto_app/studentpage.dart';
import 'package:flutter/material.dart';
import 'package:auto_app/driverpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with the path to your logo image
              width: 200, // Set the width of the logo
              height: 200, // Set the height of the logo
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverPage()),
                );
                // Add your action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 0, 0, 0), // Button background color
                minimumSize: Size(250, 70), // Set the button size
              ),
              child: Text(
                'Driver',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ), // Set the text size
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebApp()),
                );
                // Add your action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 0, 0, 0), // Button background color
                minimumSize: Size(250, 70), // Set the button size
              ),
              child: Text(
                'Student',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ), // Set the text size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
