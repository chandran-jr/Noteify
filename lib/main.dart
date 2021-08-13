import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

int total = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Noteify'))),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Container(
              height: 180.0,
              width: 180.0,
              child: FittedBox(
                child: FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  // Provide an onPressed callback.
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Construct the path where the image should be saved using the
                      // pattern package.
                      final path = join(
                        // Store the picture in the temp directory.
                        // Find the temp directory using the `path_provider` plugin.
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png',
                      );

                      // Attempt to take a picture and log where it's been saved.
                      await _controller.takePicture(path);

                      // If the picture was taken, display it on a new screen.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(path),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  DisplayPictureScreen(this.imagePath);
  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List op;
  Image img;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    img = Image.file(File(widget.imagePath));
    classifyImage(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
//    Image img = Image.file(File(widget.imagePath));
//    classifyImage(widget.imagePath, total);

    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Center(child: img)),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> runTextToSpeech(String outputMoney, int totalMoney) async {
    FlutterTts flutterTts;
    flutterTts = new FlutterTts();

    if (outputMoney == "50 rupees") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString = "Fifty rupees, Your total is now rupees, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "100 rupees") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString = "One Hundred rupees, Your total is now rupees, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "200 rupees") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString = "Two Hundred rupees, Your total is now rupees, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "500 rupees") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString =
          "Five Hundred rupees, Your total is now rupees, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney == "2000 rupees") {
      String tot = totalMoney.toString();
      print(tot);
      String speakString =
          "Two thousand rupees, Your total is now rupees, $tot";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
  }

  classifyImage(String image) async {
    var output = await Tflite.runModelOnImage(
      path: image,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    op = output;

    if (op != null) {
      if (op[0]["label"] == "50 rupees") {
        total += 50;
        runTextToSpeech("50 rupees", total);
      }
      if (op[0]["label"] == "100 rupees") {
        total += 100;
        runTextToSpeech("100 rupees", total);
      }
      if (op[0]["label"] == "200 rupees") {
        total += 200;
        runTextToSpeech("200 rupees", total);
      }
      if (op[0]["label"] == "500 rupees") {
        total += 500;
        runTextToSpeech("500 rupees", total);
      }

      if (op[0]["label"] == "2000 rupees") {
        total += 2000;
        runTextToSpeech("2000 rupees", total);
      }
    } else
      runTextToSpeech("No note found", total);
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
