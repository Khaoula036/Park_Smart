import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20), // Ajuster la marge en haut et en bas
              child: Image.asset('assets/PS_Logo.png', width: 200, height: 200),
            ),
            Text(
              "ParkSmart",
              style: GoogleFonts.poppins(
                fontSize: 65,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Marge entre le texte "ParkSmart" et le texte suivant
            const Text("Le Compagnon Idéal Pour Votre Stationnement"),
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors de l'appui sur "Sign Up"
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: const Text("Sign Up"),
            ),
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors de l'appui sur "Login"
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
