import 'package:flutter/material.dart';
import 'package:keypod/screens/about_dialog.dart';
import 'package:keypod/screens/data_table.dart';
import 'package:keypod/screens/edit_keyvalue.dart';
import 'package:keypod/screens/home.dart';
import 'package:keypod/utils/rdf.dart';
import 'package:solidpod/solidpod.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Color(0xFFF0E4D7),
      ),
      backgroundColor: Color(0xFFF0E4D7),
      body: Stack(
        children: <Widget>[
          _buildMainContent(),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildButton('KEYPODS', _writePrivateData),
            _buildButton('TESTING', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            }),
          ],
        ),
        Expanded(child: Container()), // Pushes the about button to the bottom
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
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title, style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _writePrivateData() async {
    const fileName = 'test-102.ttl';

    try {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Placeholder for your file and data operations
      await Future.delayed(Duration(seconds: 2)); // Simulating a network call

      // Navigate or perform additional actions after loading

      final dataDirPath = await getDataDirPath();
      final filePath = path.join(dataDirPath, fileName);

      final fileContent = await readPod(filePath, context, const Home());
      final pairs = fileContent == null ? null : await parseTTLStr(fileContent);
      // Convert each tuple to a Map
      List<Map<String, dynamic>>? keyValuePairs = pairs?.map((pair) {
        return {'key': pair.key, 'value': pair.value};
      }).toList();

      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => KeyValueTable(
                  title: 'Key Value Pair Editor',
                  fileName: fileName,
                  keyValuePairs: keyValuePairs,
                  child: HomeScreen())));
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }
}
