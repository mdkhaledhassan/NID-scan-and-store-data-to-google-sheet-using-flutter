import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'google_sheets_service.dart';
import 'nid_data.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  String _nid = "NID: Not Found";
  String _name = "Name: Not Found";
  String _dob = "DOB: Not Found";

  static Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  static Future<String> extractTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textDetector.processImage(
      inputImage,
    );
    await textDetector.close();
    print(recognizedText.text);
    return recognizedText.text;
  }

  Future<void> processImage(ImageSource source) async {
    final pickedIimage = await pickImage(source);
    if (pickedIimage == null) return;

    setState(() {
      image = pickedIimage;
    });

    final extractedText = await extractTextFromImage(image!);

    setState(() {
      _nid = "NID: ${NIDData.nid(extractedText)}";
      _name = "Name: ${NIDData.name(extractedText)}";
      _dob = "DOB: ${NIDData.dob(extractedText)}";
    });
  }

  Future<void> saveToGoogleSheets() async {
    if (_nid.contains("Not Found")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("NID Number not found!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await GoogleSheetsService.insertIntoGoogleSheet(
      _nid.replaceAll("NID: ", ""),
      _name.replaceAll("Name: ", ""),
      _dob.replaceAll("DOB: ", ""),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Data saved to Google Sheets!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('NID Data'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Image.file(image!, width: 200, height: 200, fit: BoxFit.cover)
                : Icon(Icons.image, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(_nid),
            Text(_name),
            Text(_dob),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => processImage(ImageSource.gallery),
                  child: Text('Pick from Gallery'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => processImage(ImageSource.camera),
                  child: Text('Capture with Camera'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: saveToGoogleSheets,
              child: Text("Save to Google Sheets"),
            ),
          ],
        ),
      ),
    );
  }
}
