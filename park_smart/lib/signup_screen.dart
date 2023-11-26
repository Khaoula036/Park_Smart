import 'package:flutter/material.dart';
import 'package:park_smart/parkingliste_screen.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _email;
  late String _password;
  late String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 0, bottom: 10), // Ajuster la marge en haut et en bas
              child: Image.asset('assets/PS_Logo.png', width: 200, height: 200),
            ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Prénom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre prénom';
              }
              return null;
            },
            onSaved: (value) {
              _firstName = value!;
            },
          ),
          const SizedBox(height: 16),
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
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez confirmer votre mot de passe';
              } else if (value != _password) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
            onSaved: (value) {
              _confirmPassword = value!;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
           // Action à effectuer lors de l'appui sur "Sign up"
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ParkingListScreen()));
            },
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Ajouter ici la logique pour traiter les données du formulaire
      print('Prénom: $_firstName');
      print('Email: $_email');
      print('Mot de passe: $_password');
      print('Confirmation du mot de passe: $_confirmPassword');
    }
  }
}

