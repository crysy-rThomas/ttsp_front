// ignore_for_file: use_build_context_synchronously

import '/services/authentication_service.dart';
import 'package:flutter/material.dart';

const snackBar = SnackBar(
  content: Text('Mauvais nom ou mot de passe renseigné'),
  backgroundColor: Colors.red,
  behavior: SnackBarBehavior.floating,
  duration: Duration(seconds: 3),
);

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nomController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Se connecter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: nomController,
                    decoration: InputDecoration(
                      hintText: 'Nom',
                      hintStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.yellow, width: 3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      hintStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.yellow, width: 3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (nomController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      
                      if (true) {
                        try {
                          await AuhtenticationService().login(nomController.text, passwordController.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                      Navigator.pushNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          right: 50.0, left: 50.0, top: 15.0, bottom: 15.0),
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Créer un compte',
                      style: TextStyle(
                        color: Color.fromARGB(240, 242, 223, 52),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
