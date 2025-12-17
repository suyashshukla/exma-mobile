import 'package:exma/services/auth-service.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(25),
              child: Image.asset("assets/exma-logo-cropped.png", height: 64),
            ),
            Text(
              "Welcome to Exma",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              "Expense Management Simplified!",
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsetsGeometry.directional(
                start: 100,
                end: 100,
                top: 25,
                bottom: 25,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Login with",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.directional(start: 90, end: 90),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Image.asset("assets/google.png", height: 24),
                  label: Text("Continue with Google"),
                  onPressed: () => handleGoogleSignIn(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.directional(start: 90, end: 90),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Image.asset("assets/microsoft.png", height: 24),
                  label: Text("Continue with Microsoft"),
                  onPressed: () => handleMicrosoftSignIn(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleMicrosoftSignIn() {}
  Future<void> handleGoogleSignIn(BuildContext context) async {
    var userCredential = await AuthService.signInWithGoogle();
    if (userCredential != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new Home()),
      );
    }
  }
}
