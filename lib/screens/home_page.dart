/// New Home Screen
///
// Time-stamp: <Sunday 2023-12-31 16:40:28 +1100 Graham Williams>
///
/// Copyright (C) 2024, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Kevin Wang

library;

import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';
import 'package:path/path.dart' as path;

import 'package:keypod/screens/about_dialog.dart';
import 'package:keypod/screens/data_table.dart';
import 'package:keypod/screens/test_home.dart';
import 'package:keypod/utils/constants.dart';
import 'package:keypod/utils/rdf.dart';

class HomeScreen extends StatefulWidget {
  ///Constructor
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: titleBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: titleBackgroundColor,
      body: Stack(
        children: <Widget>[
          _buildMainContent(),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
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
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildButton('KEYPODS', _writePrivateData),
            _buildButton('TESTING', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestHome()),
              );
            }),
          ],
        ),
        // Pushes the about button to the bottom.

        Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.all(20),
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
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }

  Future<void> _writePrivateData() async {
    const fileName = dataFile;

    try {
      setState(() {
        // Show loading indicator.

        _isLoading = true;
      });

      // Simulating a network call.

      await Future.delayed(const Duration(seconds: 2));

      // Navigate or perform additional actions after loading

      final dataDirPath = await getDataDirPath();
      final filePath = path.join(dataDirPath, fileName);

      final fileContent = await readPod(filePath, context, const TestHome());
      final pairs = fileContent == null ? null : await parseTTLStr(fileContent);
      // Convert each tuple to a Map.

      final keyValuePairs = pairs?.map((pair) {
        return {'key': pair.key, 'value': pair.value};
      }).toList();

      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => KeyValueTable(
                  title: 'Key Value Pair Editor',
                  fileName: fileName,
                  keyValuePairs: keyValuePairs,
                  child: const HomeScreen())));
    } on Exception catch (e) {
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
