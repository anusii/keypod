/// Home page after user creating account.
///
// Time-stamp: <Thursday 2024-04-11 21:58:54 +1000 Graham Williams>
///
/// Copyright (C) 2024, Software Innovation Institute, ANU.
///
/// Licensed under the MIT License (the "License").
///
/// License: https://choosealicense.com/licenses/mit/.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///
/// Authors: Zheyuan Xu, Anushka Vidanage

// TODO 20240411 gjw WHY THE IGNORE? EXPLAIN HERE

// ignore_for_file: use_build_context_synchronously

library;

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:keypod/main.dart';
import 'package:keypod/screens/about_dialog.dart';
import 'package:keypod/screens/view_keys.dart';
import 'package:path/path.dart' as path;

import 'package:solidpod/solidpod.dart';

/// Widget represents the home screen of the application.
///
/// This is because this page is designed to be work in offline as well.

class Home extends StatefulWidget {
  /// Initialise widget variables

  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String sampleText = '';
  // Step 1: Loading state variable.

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showPrivateData() async {
    setState(() {
      // Begin loading.

      _isLoading = true;
    });

    final appName = await getAppName();
    try {
      final filePath = '$appName/encryption/enc-keys.ttl';
      //final filePath = '$appName/data/test-101.ttl';
      final fileContent = await readPod(
        filePath,
        context,
        const Home(),
      );

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewKeys(
            keyInfo: fileContent,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          // End loading.

          _isLoading = false;
        });
      }
    }
  }

  Future<void> _writePrivateData() async {
    setState(() {
      // Begin loading.

      _isLoading = true;
    });

    final appName = await getAppName();
    try {
      final filePath = '$appName/data/test-101.ttl';
      final fileContent = 'This is for testing writePod.';
      await writePod(
        filePath,
        fileContent,
        context,
        const Home(),
      );
    } on Exception catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: lightGreen,
        centerTitle: true,
        title: const Text('KeyPod'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () async {
              aboutDialog(context);
            },
            tooltip: 'Popup a window about the app.',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KeyPod()),
            );
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child:
                  // Step 2: Show loading indicator.

                  CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  //const ShowKeys(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: $dateStr',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to your new app!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          child: const Text('Show private data'),
                          onPressed: () async {
                            await _showPrivateData();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          child: const Text('Write private data'),
                          onPressed: () async {
                            await _writePrivateData();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          child: const Text('Delete login data'),
                          onPressed: () async {
                            final deleteRes = await deleteLogIn();

                            var deleteMsg = '';

                            if (deleteRes) {
                              deleteMsg = 'Successfully deleted login info';
                            } else {
                              deleteMsg =
                                  'Failed to delete login info. Try again in a while';
                            }

                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Notice'),
                                content: Text(deleteMsg),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'))
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
