/* class _FeedScreenState extends State<FeedScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _title = '';
  String? _category = ' ';
  String? _geotag = '';
  String? _imagePath = '';

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    await FirebaseFirestore.instance
        .collection('brugbart')
        .doc()
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          snapshot.data()!["title"];
          snapshot.data()!["geotag"];
          snapshot.data()!["category"];
          snapshot.data()!["imageURL"];
        });
      }
    });
    try {
      final snapshot = await _db.collection('brugbart').get();
      final List<String> imageUrls =
          snapshot.docs.map((doc) => doc['url'].toString()).toList();
      setState(() {
        _imageUrls = imageUrls;
      });
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
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
