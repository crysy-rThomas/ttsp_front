// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import './pages/introductionPages/introduction.dart';
import './pages/loginPages/login.dart';
import './pages/loginPages/register.dart';
import 'package:flutter/material.dart';

import 'pages/documentPages/document.dart';
import 'pages/historyPages/history.dart';
import 'pages/chatPages/chat.dart';
var pos = 0;
GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final Introduction introduction = const Introduction();
  final Login login = const Login();
  final Register register = const Register();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTSPAPP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 231, 19)),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => login,
        '/register': (context) => register,
        '/welcome': (context) => introduction,
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
    final List<Color> pageColors = [
    Colors.blueAccent, // Color for Accueil
    Colors.greenAccent, // Color for History
    Colors.deepOrangeAccent, // Color for Document
  ];
  @override
  Widget build(BuildContext context) {
    Widget page = const Chat();

    switch (pos) {
      case 0:
        page = const Chat();
        break;
      case 1:
        page = History(setPageCallback: setPage);
        break;
      case 2:
        page = const Document();
        break;
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: page,
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: pageColors[pos],
          items: <Widget>[
            const Icon(Icons.chat),
            const Icon(Icons.history),
            const Icon(Icons.edit_document),
          ],
          onTap: (value) {
            setState(() {
              pos = value;
            });
          },
        ),
        
      );
      
    });
  }
  void setPage(int index) {
    setState(() {
      pos = index;
    });
    _bottomNavigationKey.currentState?.setPage(index);
  }
}

  
  
  void navigateToPage(BuildContext context, String route) {
      Navigator.pushNamed(context, route);
  }

