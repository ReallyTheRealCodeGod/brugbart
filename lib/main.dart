import 'dart:io';
import 'dart:typed_data';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      backgroundColor: Color.fromARGB(255, 251, 245, 236),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the upload screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  backgroundColor: Color.fromARGB(255, 250, 226, 105),
                  elevation: 0,
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Upload brugbart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Avenir',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the feed screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  backgroundColor: Color.fromARGB(255, 255, 163, 65),
                  elevation: 0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Find brugbart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Avenir',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
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

final ScrollController _firstController = ScrollController();

class _UploadScreenState extends State<UploadScreen> {
  // Variables for the form fields
  late String _title;
  String? _category = 'Træ';
  String? _geotag;
  File? _imagePath;

  final List<String> _categories = [
    'Træ',
    'Metal',
    'Andet',
  ];

  // Controller for the form fields
  final _formKey = GlobalKey<FormState>();

  // Uploads the image to Firebase Storage
  Future<String> uploadImageToFirebaseStorage() async {
    if (_imagePath == null) {
      throw Exception('No image selected');
    }
    final fileName = path.basename(_imagePath!.path);
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/$fileName');
    final uploadTask = ref.putFile(_imagePath!);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Upload brugbart',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.w900,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Scrollbar(
          thumbVisibility: true,
          controller: _firstController,
          child: SingleChildScrollView(
            controller: _firstController,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField<String?>(
                    value: _category,
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Titel',
                      hintStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Skriv venligst en titel';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Geotag',
                      hintStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text(
                          'Vælg billede',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Avenir',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Color.fromARGB(255, 135, 89, 89),
                          elevation: 0,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                      SizedBox(width: 10),
                      Text(
                        '/',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text(
                          'Tag nyt billede',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Avenir',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Color.fromARGB(255, 135, 89, 89),
                          elevation: 0,
                        ),
                        onPressed: () {
                          takePhoto();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  showImage(),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Avenir',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 163, 65),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        // Validate the form fields
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Show a progress indicator while uploading
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(child: CircularProgressIndicator());
                            },
                            barrierDismissible: false,
                          );
                          // Call the uploadImageToFirebaseStorage
                          String? imageUrl =
                              await uploadImageToFirebaseStorage();
                          // Create a Firestore document with the form data and the uploaded image URL
                          if (imageUrl != null) {
                            await FirebaseFirestore.instance
                                .collection('brugbart')
                                .add({
                              'title': _title,
                              'category': _category,
                              'geotag': _geotag,
                              'imageUrl': imageUrl,
                            });
                          }
                          // Close the progress indicator dialog
                          Navigator.pop(context);
                          // Navigate back to the previous screen
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
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

  Future<void> saveImage(String imageUrl) async {
    // Get the bytes of the image
    Uint8List bytes = await getBytesFromUrl(imageUrl);
    // Save the image to the photo gallery
    await ImageGallerySaver.saveImage(bytes);
  }

  Future<Uint8List> getBytesFromUrl(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

// Function to get the image from the device
  Future getImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagePath = File(pickedImage.path);
      });
    }
  }

  /// A method that opens the camera app to take a photo, and sets the resulting image as the current image path.
  /// If a photo is successfully taken and saved, the [setState] method is called to update the UI with the new image.
  /// If the user cancels or encounters an error, the [takenImage] variable will be null and no changes to the UI will be made.
  Future takePhoto() async {
    final XFile? takenImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (takenImage != null) {
      setState(() {
        _imagePath = File(takenImage.path);
      });
    }
  }

// Function to display the selected image
  Widget showImage() {
    if (_imagePath != null) {
      return Image.file(_imagePath!, fit: BoxFit.cover);
    } else {
      return Container();
    }
  }
}

// class FeedScreen extends StatelessWidget {
//   const FeedScreen({super.key});
//   @override
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
// }

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final snapshot = await _db.collection('brugbart').get();
      final List<Map<String, dynamic>> posts =
          snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Feed',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index) {
          final post = _posts[index];
          final backgroundColor =
              Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                  .withOpacity(0.8);
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitle(post['title'] ?? ''),
                const SizedBox(height: 8),
                _buildGeotag(post['geotag'] ?? ''),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: post['imageUrl'] == null
                        ? Placeholder()
                        : Image.network(
                            post['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCategory(post['category'] ?? ''),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(String? title) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        title ?? '',
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildGeotag(String? geotag) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.white,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          geotag ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(String? category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        category ?? '',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}
