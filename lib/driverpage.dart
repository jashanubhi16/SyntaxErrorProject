import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_app/successfullogin.dart';
// import 'package:http/http.dart' as http;

class DriverPage extends StatefulWidget {
  DriverPage({super.key});

  @override
  State<DriverPage> createState() => DriverPageState();
}

class DriverPageState extends State<DriverPage> {
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  String enteredText1 = '';
  String enteredText2 = '';

  void _showWrongPasswordPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid Driver Number'),
          content: Text('Enter a valid driver number'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showWrongPasswordPopup1() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invalid Passoword'),
          content: Text('Enter a valid Password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void checkNumber(String x, String y) {
    int xint = int.parse(x);
    if (xint < 1 || xint > 50) {
      _showWrongPasswordPopup();
    }
    int yint = int.parse(y);
    if (yint != (100 * log(2 * xint)).ceil()) {
      _showWrongPasswordPopup1();
    }
    if (xint >= 1 && xint <= 50 && yint == (100 * log(2 * xint)).ceil()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebApp()),
      );
    }
  }

  void _updateEnteredText1() {
    setState(() {
      enteredText1 = textController1.text;
      enteredText2 = textController2.text;
      checkNumber(enteredText1, enteredText2);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Info'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Details',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              width: 300, // Set the desired width
              child: TextField(
                controller: textController1,
                decoration: InputDecoration(
                  labelText: 'Driver Number',
                  labelStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300, // Set the desired width
              child: TextField(
                controller: textController2,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            ElevatedButton(
              onPressed: _updateEnteredText1,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 0, 0, 0), // Button background color
                minimumSize: Size(250, 70), // Set the button size
              ),
              child: Text(
                'Login',
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
