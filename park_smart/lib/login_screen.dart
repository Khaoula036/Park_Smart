import 'package:flutter/material.dart';
import 'package:park_smart/liste_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre adresse e-mail';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                // Action à effectuer lors de l'appui sur "Login"
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ParkingScreen()));
              },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Ajoutez ici la logique pour traiter les données du formulaire
      print('Email: $_email');
      print('Mot de passe: $_password');

      // On peut ajouter ici la logique d'authentification, par exemple vérifier les informations avec un backend
    }
  }
}
