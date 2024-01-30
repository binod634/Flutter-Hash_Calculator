import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'Screens/app_screens.dart';
void main() {
  runApp(const AppMeta());
}

class AppMeta extends StatelessWidget  {
  const AppMeta({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "This is Sample App",
      home: const AppState(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
      ),
    );
  }
}

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<StatefulWidget> createState() => AppHomeImpl();
}

class AppHomeImpl extends State<AppState> {

  // AppScreens to show
  AppScreen currentScreen = AppScreen.textView;
  // hash value
  String? hash;

  // change Screens to somethings
  void changeScreen(int index) => setState(() {
        currentScreen = AppScreen.values[index];
      });

  void updateHash(String str) {
    String newHash =  md5.convert(utf8.encode(str)).toString();
    setState(() {
      hash = newHash;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hash Calculator",style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       centerTitle: true),
      body:  Center(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Text"
              ),
              onChanged: updateHash,
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 25), child: Text("MD5:  ${hash ?? 'Null'}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),)
            )
          ],
        ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: changeScreen,
        currentIndex: currentScreen.index,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: "Text",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: "File",
          )
        ],
      ),   
    );
  }
}

