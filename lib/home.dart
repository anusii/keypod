/// A simple key value table for the home screen.
///
// Time-stamp: <Monday 2024-07-08 13:42:31 +1000 Graham Williams>
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
/// Authors: Kevin Wang, Graham Williams

// TODO 20240526 gjw EITHER REPAIR ALL CONTEXT ISSUES OR EXPLAIN WHY NOT?

// REMOVE ignore_for_file: use_build_context_synchronously

library;

import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';
import 'package:path/path.dart' as path;

import 'package:keypod/features/key_value_editor.dart';
import 'package:keypod/screens/demo.dart';
import 'package:keypod/utils/constants.dart';
import 'package:keypod/utils/rdf.dart';

class Home extends StatefulWidget {
  /// Constructor for the home screen.

  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

///

class HomeState extends State<Home> {
  ////////////////////////////////////////////////////////////////////////
  // STATE
  ////////////////////////////////////////////////////////////////////////

  // Track if the data is loading.

  bool _isLoading = false;

  ////////////////////////////////////////////////////////////////////////
  // WRITE PRIVATE DATA
  ////////////////////////////////////////////////////////////////////////

  Future<void> _writePrivateData() async {
    // TODO 20240708 gjw PLEASE DESCRIBE WAHT THIS FUNCTION FOR FOR

    const fileName = dataFile;

    try {
      setState(() {
        // Show the loading indicator.
        _isLoading = true;
      });

      // TODO (dc): Please explain this simulation, why is it necessary?
      // Simulate a network call.

      // await Future.delayed(const Duration(seconds: 2));

      // Navigate or perform additional actions after loading
      final dataDirPath = await getDataDirPath();
      final filePath = path.join(dataDirPath, fileName);

      final fileContent = await readPod(filePath, context, const DemoScreen());
      final pairs = fileContent == null ? null : await parseTTLStr(fileContent);

      // Convert each tuple to a map.

      final keyValuePairs = pairs?.map((pair) {
        return {'key': pair.key, 'value': pair.value};
      }).toList();

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KeyValueEditor(
            title: 'Key Value Pair Editor',
            fileName: fileName,
            keyValuePairs: keyValuePairs,
            child: const Home(),
          ),
        ),
      );
    } on Exception catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          // Hide the loading indicator.

          _isLoading = false;
        });
      }
    }
  }

  // TODO 20240708 gjw BETTER EXPLAIN WHY THIS INIT IS REQUIRED

  @override
  void initState() {
    super.initState();

    // Automatically tap the KEYPODS button when the screen loads. WHAT KEYPODS
    // BUTTON?

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _writePrivateData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Key Value Pairs... '),
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
        Expanded(child: Container()),
      ],
    );
  }
}
