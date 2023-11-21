import 'package:flutter/material.dart';
import 'package:park_smart/signup_screen.dart'; 
import 'package:park_smart/login_screen.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 0, bottom: 5), // Ajuster la marge en haut et en bas
              child: Image.asset('assets/PS_Logo.png', width: 300, height: 300),
            ),
            const Text(
              "ParkSmart",
              style: TextStyle(
                fontSize: 65,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),    // Marge entre le texte "ParkSmart" et le texte suivant
            const Text(
              "Le Compagnon Idéal Pour Votre Stationnement",
               style: TextStyle(
                fontSize: 18,
              ),
              ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors de l'appui sur "Sign Up"
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
              },
              child: const Text("Sign Up",
               style: TextStyle(
                fontSize: 25,
              ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors de l'appui sur "Login"
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: const Text("Login",
               style: TextStyle(
                fontSize: 25,
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
