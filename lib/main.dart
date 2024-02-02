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

  // change Screens to somethings
  void changeScreen(int index) => setState(() {
    setState(() {
      currentScreen = AppScreen.values[index];
    });
    }
  );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Hash Calculator",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true),
      body:  Center(
        child: Stack(
          children: [
            Visibility(
              visible: currentScreen == AppScreen.textView,
              child: const AppTextView(),
            ),
            Visibility(
              visible: currentScreen == AppScreen.fileView,
               child: const AppFileView()
            )
          ],
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

class AppTextView extends StatefulWidget {
  const AppTextView({super.key});

  @override
  State<StatefulWidget> createState() => AppTextViewImpl();
}

class AppTextViewImpl extends State<AppTextView> {
  String? hash;

  void updateHashFromText(String str) {
    String newHash = md5.convert(utf8.encode(str)).toString();
    setState(() {
      hash = newHash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Text"),
            onChanged: updateHashFromText,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: SelectableText(
                hash != null ? "MD5: $hash" : "Type something.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}

class AppFileView extends StatefulWidget {
  const AppFileView({super.key});


  @override
  State<StatefulWidget> createState() => AppFileViewImpl();
}

class AppFileViewImpl extends State<AppFileView> {
  String? hash;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      hashFile(result);
      Fluttertoast.showToast(msg: "File Encrypted.");
    }
  }
  
  Future<void> hashFile(FilePickerResult filePickerResult) async {
    List<Hash> listAllHashes = [
      md5,
      sha224,
      sha1,
      sha256,
      sha512,
      sha384,
    ];
    
    File file = File(filePickerResult.paths.first!);
    setState(() {
      hash = md5.convert(file.readAsBytesSync()).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(onPressed: pickFile, clipBehavior: Clip.hardEdge, icon: const Icon(Icons.file_copy),
        label: const Text("Pick File"),),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
        SelectableText(hash != null ? "MD5: $hash" : "Pick a File First.",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
