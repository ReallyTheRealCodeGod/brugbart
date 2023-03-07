import 'dart:io';
import 'dart:typed_data';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
/*   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 */
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
                "Velkommen til vores geniale app til genbrugsmaterialer!",
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
                  MaterialPageRoute(builder: (context) => FeedScreen()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload brugbart'),
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
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Titel',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Skriv venligst en titel';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value!,
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
                      /*              String url = */
                      /*                       'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fcaucasian-smooth-skinned-teen-grimacing-hands-next-to-face-funny-white-long-sleeved-t-shirt-smiles-waving-51910820.jpg&f=1&nofb=1&ipt=5c9ff8f33a596211c84a60710642541145de2d4cc4dd0d3a8ff60323462b2792&ipo=images';
                    saveImage(url); */
                      getImage();
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('tag nyt billede'),
                    onPressed: () {
                      /*              String url = */
                      /*                       'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fcaucasian-smooth-skinned-teen-grimacing-hands-next-to-face-funny-white-long-sleeved-t-shirt-smiles-waving-51910820.jpg&f=1&nofb=1&ipt=5c9ff8f33a596211c84a60710642541145de2d4cc4dd0d3a8ff60323462b2792&ipo=images';
                    saveImage(url); */
                      takePhoto();
                    },
                  ),
                  SizedBox(height: 20),
                  showImage(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Upload'),
                    onPressed: () {},
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
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final response = await http.get(Uri.parse('https://example.com/images'));
      if (response.statusCode == 200) {
        final List<String> imageUrls =
            List<String>.from(jsonDecode(response.body));
        setState(() {
          _imageUrls = imageUrls;
        });
      } else {
        print('Error loading images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading images: $e');
    } finally {
      if (_imageUrls.isEmpty) {
        setState(() {
          _imageUrls = List.generate(20, (_) => '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: ListView.builder(
        itemCount: _imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          final imageUrl = _imageUrls[index];
          final backgroundColor =
              Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                  .withOpacity(1.0);
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: backgroundColor,
            child: SizedBox(
              height: 600, // height of an Instagram photo
              width: 600, // width of an Instagram photo
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Placeholder(
                          fallbackHeight: 600.0,
                          fallbackWidth: 600.0,
                        );
                      },
                    )
                  : Placeholder(
                      fallbackHeight: 600.0,
                      fallbackWidth: 600.0,
                    ),
            ),
          );
        },
      ),
    );
  }
}
