import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Screens/app_screens.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const AppMeta());
}

class AppMeta extends StatelessWidget {
  const AppMeta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "This is Sample App",
      initialRoute: AppScreen.textView.name,
      routes: {
        AppScreen.textView.name: (context) => const AppState(),
        AppScreen.fileView.name: (context) => const AppSecondState(),
      },
      home: const AppState(),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
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
        Navigator.pushNamed(context, currentScreen.name);
        currentScreen = AppScreen.fileView; // Should have exitted File view already.
      });

  void updateHash(String str) {
    String newHash = md5.convert(utf8.encode(str)).toString();
    setState(() {
      hash = newHash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Hash Calculator",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Text"),
                onChanged: updateHash,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    "MD5:  ${hash ?? 'Null'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ))
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

class AppSecondState extends StatefulWidget {
  const AppSecondState({super.key});

  @override
  State<StatefulWidget> createState() => SecondScreen();
}

class SecondScreen extends State<AppSecondState> {
  String? hash;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      hashFile(result);
      Fluttertoast.showToast(msg: "Hello");
     }
  }

  Future<void> hashFile(FilePickerResult filePickerResult) async {
    File file = File(filePickerResult.paths.first!);
    setState(() {
      hash = md5.convert(file.readAsBytesSync()).toString();
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "File Upload",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(hash ?? 'Null',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            FilledButton(onPressed: pickFile, child: const Text("Pick File")  
            ),
          ],
        ),
      ),
    );
  }
}
