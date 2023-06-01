import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  File? _image;
  String scannedText = "";
  bool _canProcess = true;
  bool _isBusy = false;
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image == null)
                Container(
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300]!,
                  ),
                ),
              if (_image != null)
                Container(
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (_image != null)
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromARGB(255, 255, 0, 0)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                            scannedText = "";
                          });
                        },
                        icon: const Icon(Icons.clear, color: Colors.white),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      processImage(_image);
                    },
                    label: const Text('RECOGNIZE TEXT'),
                    icon: const Icon(Icons.description),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 103, 209),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        minimumSize:
                            Size(1, MediaQuery.of(context).size.height * 0.05),
                        textStyle: const TextStyle(fontSize: 20) //////// HERE
                        ),
                  ),
                ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton.icon(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
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
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
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
              ]),
              if (scannedText != "")
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Recognized text:'),
                  Container(
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[300]!,
                    ),
                    child: Center(
                      child: Text(scannedText),
                    ),
                  ),
                ])
            ],
          ),
        ));
  }

  void pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> processImage(File? image) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      scannedText = '';
    });
    final InputImage inputImage = InputImage.fromFilePath(image!.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    scannedText = recognizedText.text;
    // TODO: set _customPaint to draw boundingRect on top of image
    print(scannedText);

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
