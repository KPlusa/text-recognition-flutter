import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyHomePage(title: 'Text Recognition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    File? _image;

    // This is the image picker
    final _picker = ImagePicker();
    // Implementing the image picker
    Future<void> _openImagePicker() async {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    }

    Future<void> _pickImageFromCamera() async {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton.icon(
                  onPressed: _openImagePicker,
                  label: const Text('PICK IMAGE'),
                  icon: const Icon(Icons.image),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 103, 209),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize:
                          Size(1, MediaQuery.of(context).size.height * 0.05),
                      textStyle: const TextStyle(fontSize: 20) //////// HERE
                      ),
                ),
                const SizedBox(
                  width: 10, // <-- SEE HERE
                ),
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('TAKE PHOTO'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 103, 209),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize:
                          Size(1, MediaQuery.of(context).size.height * 0.05),
                      textStyle: const TextStyle(fontSize: 20) //////// HERE
                      ),
                ),
              ])
            ],
          ),
        ));
  }
}
