import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,

        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: const MyHomePage(title: 'Brugbart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                "Velkommen til vores geniale app til genbrugsmaterialer! Vores app er designet til at hjælpe dig med at dele genbrugsmaterialer med andre og samtidig spare penge og ressourcer. Det er nemt at bruge vores app - alt hvad du skal gøre er at uploade de materialer, som du gerne vil give væk, og andre brugere vil kunne se dem og kontakte dig for at aftale afhentning. Vores app er en win-win situation for både dig og miljøet, så lad os sammen gøre verden til et mere bæredygtigt sted!",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the upload screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
                );
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 70)),
              child: const Text('Upload brugbart'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the feed screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedScreen()),
                );
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 70)),
              child: const Text('Find brugbart'),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // Variables for the form fields
  late String _title;
  String? _category;
  String? _geotag;
  Image _imagePath = Image.file(
  File? _imagePath = Image.file(
  Image _imagePath = Image.file(
      File("C:\dev\test_app\assets\Images\dancing with red dwarf demons.png"));

  // Controller for the form fields
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload brugbart'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Titel',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Skriv venligst en titel';
                  }
                  if (value.isEmpty) {
                    return 'Skriv venligst en titel';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Kategori',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Skriv venligst en kategori';
                  }
                  if (value.isEmpty) {
                    return 'Skriv venligst en kategori';
                  }
                  return null;
                },
                onSaved: (value) => _category = value,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Geotag',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Skriv venligst en geotag';
                  }
                  return null;
                },
                onSaved: (value) => _geotag = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Vælg billede'),
                onPressed: () {
                  // Open the image picker
                  getImage();
                },
              ),
              SizedBox(height: 20),
              showImage(),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Upload'),
                onPressed: () {
                  showImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

/* class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('upload Screen'),
      ),
      body: const Center(
        child: Text('You have arrived at the next screen.'),

//button, with a plus sign, t

      ),
    );
  }
} */

// Function to get the image from the device
  Future getImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagePath = File(pickedImage.path) as Image;
        _imagePath = File(pickedImage.path);
        _imagePath = File(pickedImage.path) as Image;
      });
    }
  }

// Function to display the selected image
  Widget showImage() {
    if (_imagePath != null) {
      return Image.file(_imagePath as File, fit: BoxFit.cover);
      return Image.file(_imagePath!, fit: BoxFit.cover);
      return Image.file(_imagePath as File, fit: BoxFit.cover);
    } else {
      return Container();
    }
  }
}

// class FeedScreen extends StatefulWidget {
// class FeedScreen extends StatelessWidget {
// class FeedScreen extends StatefulWidget {
//   const FeedScreen({super.key});
//   @override
//   _FeedScreenState createState() => _FeedScreenState
  
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Next Screen'),
//       ),
//       body: const Center(
//         child: Text('You have arrived at the next screen.'),
//       ),
//     );
//   }
//   _FeedScreenState createState() => _FeedScreenState
  
// }

// class _FeedscreenState extends State<FeedScreen> {

// }