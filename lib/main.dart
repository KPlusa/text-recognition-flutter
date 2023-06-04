import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyHomePage(title: 'Text Recognition'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String scannedText = "";
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
            if (_image == null) ...[
              _buildContainer(screenWidth),
            ] else ...[
              _buildContainer(screenWidth),
              _buildImageButtonsRow(),
              const SizedBox(height: 10),
            ],
            _buildButtonsRow(),
            if (scannedText.isNotEmpty) ...[
              _buildScannedTextContainer(screenWidth),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(double screenWidth) {
    return Container(
      width: screenWidth * 0.8,
      height: screenWidth * 0.8,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _image == null ? Colors.grey[300] : null,
        image: _image != null
            ? DecorationImage(
                image: FileImage(_image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }

  Widget _buildImageButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(Icons.clear, Colors.white, _clearImage),
        const SizedBox(width: 10),
        _buildElevatedButton(
          'RECOGNIZE TEXT',
          Icons.description,
          const Color.fromARGB(255, 4, 103, 209),
          _image != null ? _processImage : null,
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildElevatedButton(
          'PICK IMAGE',
          Icons.image,
          const Color.fromARGB(255, 4, 103, 209),
          () => pickImage(ImageSource.gallery),
        ),
        const SizedBox(width: 10),
        _buildElevatedButton(
          'TAKE PHOTO',
          Icons.photo_camera,
          const Color.fromARGB(255, 4, 103, 209),
          () => pickImage(ImageSource.camera),
        ),
      ],
    );
  }

  Widget _buildScannedTextContainer(double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenWidth * 0.5,
          height: screenWidth * 0.5,
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300]!,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    'Recognized text:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: SelectableText(
                    scannedText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
      IconData iconData, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 255, 0, 0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(iconData, color: color),
      ),
    );
  }

  Widget _buildElevatedButton(
    String label,
    IconData iconData,
    Color backgroundColor,
    VoidCallback? onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed != null ? () => onPressed() : null,
      label: Text(label),
      icon: Icon(iconData),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        minimumSize: Size(
          1,
          MediaQuery.of(context).size.height * 0.05,
        ),
        textStyle: const TextStyle(fontSize: 20),
      ),
    );
  }

  Future<void> pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _processImage() async {
    if (_isBusy || _image == null) return;

    setState(() {
      scannedText = '';
      _isBusy = true;
    });

    final InputImage inputImage = InputImage.fromFilePath(_image!.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    setState(() {
      scannedText = recognizedText.text;
      _isBusy = false;
    });
  }

  void _clearImage() {
    setState(() {
      _image = null;
      scannedText = '';
    });
  }
}
