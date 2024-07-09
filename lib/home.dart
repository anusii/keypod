/// A simple key value table for the home screen.
///
// Time-stamp: <Wednesday 2024-07-10 09:34:33 +1000 Graham Williams>
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
import 'package:keypod/constants/colours.dart';
import 'package:keypod/utils/rdf.dart';

class Home extends StatefulWidget {
  /// Constructor for the home screen.

  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

///

class HomeState extends State<Home> {
  // Track if the data is loading.

  bool _isLoading = false;

  Future<void> _writePrivateData(BuildContext context) async {
    // TODO 20240708 gjw PLEASE DESCRIBE WHAT THIS FUNCTION DOES

    const fileName = 'key-value.ttl';

    try {
      setState(() {
        // Show the loading indicator.

        _isLoading = true;
      });

      // TODO dc: PLEASE EXPLAIN THIS SIMULATION, WHY IS IT NECESSARY?
      //
      // Simulate a network call.

      // await Future.delayed(const Duration(seconds: 2));

      // Navigate or perform additional actions after loading.

      final dataDirPath = await getDataDirPath();
      final filePath = path.join(dataDirPath, fileName);

      // TODO 20240708 gjw WHY IS DemoScreen (OR ANY WIDGET) HERE?
      //
      // I repalced DemoScreen with Text(). Still works. I have also removed
      // demo.dart. It is not part of this app now.

      // TODO 20240708 gjw FIX CONTEXT ACROSS ASYNC GAPS.
      //
      // I added context as a function parameter and added the checks on
      // context.mounted. Seems to fix the lint. But the real solution might be
      // a restructure. The BuildContext is used for navigation etc. Is it
      // needed in readPod. Seems like it would be better to use a provider in
      // readPod (using riverPod?) to test login etc? It seems to be being used
      // to track state.

      if (context.mounted) {
        final fileContent = await readPod(filePath, context, const Text('Why'));

        final pairs =
            fileContent == null ? null : await parseTTLStr(fileContent);

        // Convert each tuple to a map.

        final keyValuePairs = pairs?.map((pair) {
          return {'key': pair.key, 'value': pair.value};
        }).toList();

        // TODO 20240708 gjw FIX CONTEXT ACROSS ASYNC GAPS

        if (context.mounted) {
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
        }
      }
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

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20),
        Expanded(child: Container()),
      ],
    );
  }

  // TODO 20240708 gjw EXPLAIN WHY THIS INIT IS REQUIRED
  //
  // Perhaps, instead, change the work flow so that on LOGIN or CONTINUE we come
  // the the main app page which simply has a central button. When pushed the
  // data is retrieved from the Solid Pod (logging in if needed) and then
  // displayed. The following is not really very transparent for a template app.

  @override
  void initState() {
    super.initState();

    // Automatically press the KEYPODS button when the screen loads. WHAT
    // KEYPODS BUTTON?

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _writePrivateData(context);
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
}
