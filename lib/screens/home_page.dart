import 'package:flutter/material.dart';
import 'package:keypod/screens/about_dialog.dart';
import 'package:keypod/screens/edit_keyvalue.dart';
import 'package:keypod/screens/home.dart';
import 'package:keypod/utils/rdf.dart';
import 'package:solidpod/solidpod.dart';
import 'package:path/path.dart' as path;

// HomeScreen is now a StatefulWidget
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// _HomeScreenState handles the state of HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor:
            Color(0xFFF0E4D7), // Set AppBar background to light brown
      ),
      backgroundColor:
          Color(0xFFF0E4D7), // Light brown color for the scaffold background
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centers the column content vertically
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Spreads the buttons evenly across the Row
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  // You can now include state-changing logic here if needed
                  await _writePrivateData();
                },
                child: Text('KEYPODS',
                    style: TextStyle(fontSize: 16)), // Larger text size
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: 20), // Larger padding
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // This navigates to another screen for TESTING
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text('TESTING',
                    style: TextStyle(fontSize: 16)), // Larger text size
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: 20), // Larger padding
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Expanded(
            child:
                Container(), // This empty container pushes the about button to the bottom
          ),
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () async {
                aboutDialog(context);
              },
              tooltip: 'Popup a window about the app.',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _writePrivateData() async {
    setState(() {
      // Begin loading.
      _isLoading = true;
    });

    // final appName = await getAppName();

    // final fileName = 'test-101.ttl';
    // final fileContent = 'This is for testing writePod.';

    const fileName = 'test-102.ttl';

    try {
      final dataDirPath = await getDataDirPath();
      final filePath = path.join(dataDirPath, fileName);

      final fileContent = await readPod(filePath, context, const Home());
      final pairs = fileContent == null ? null : await parseTTLStr(fileContent);

      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => KeyValueEdit(
                  title: 'Key Value Pair Editor',
                  fileName: fileName,
                  keyValuePairs: pairs,
                  child: const Home())));
    } on Exception catch (e) {
      print('Exception: $e');
    } finally {
      if (mounted) {
        setState(() {
          // End loading.
          _isLoading = false;
        });
      }
    }
  }
}
