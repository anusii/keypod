/// Home page after user creating account.
///
// Time-stamp: <Friday 2024-05-10 11:04:30 +1000 Graham Williams>
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
/// Authors: Zheyuan Xu, Anushka Vidanage, Kevin Wang, Dawei Chen, Graham Williams

// TODO 20240411 gjw WHY THE IGNORE? EXPLAIN HERE

// ignore_for_file: use_build_context_synchronously

library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keypod/main.dart';
import 'package:keypod/screens/about_dialog.dart';
import 'package:keypod/screens/data_table.dart';
import 'package:keypod/screens/edit_keyvalue.dart';
import 'package:keypod/screens/view_keys.dart';
import 'package:keypod/utils/rdf.dart';
import 'package:path/path.dart' as path;

import 'package:solidpod/solidpod.dart'
    show
        deleteLogIn,
        getAppNameVersion,
        getEncKeyPath,
        getDataDirPath,
        logoutPopup,
        readPod,
        removeMasterPassword,
        changeKeyPopup;

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

  Future<void> _showPrivateData(String title) async {
    setState(() {
      // Begin loading.

      _isLoading = true;
    });

    // final appName = await getAppName();
    try {
      // final filePath = '$appName/encryption/enc-keys.ttl';
      final filePath = await getEncKeyPath();
      final fileContent = await readPod(
        filePath,
        context,
        const Home(),
      );

      //await Navigator.pushReplacement( // this won't show the file content if POD initialisation has just been performed
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewKeys(
            keyInfo: fileContent!,
            title: title,
          ),
        ),
      );
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

  Widget _build(BuildContext context, String title) {
    final dateStr = DateFormat('dd MMMM yyyy').format(DateTime.now());
    const smallButtonGap = 10.0;
    const largeButtonGap = 40.0;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: lightGreen,
        centerTitle: true,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.purple,
            ),
            onPressed: () async {
              aboutDialog(context);
            },
            tooltip: 'Popup a window about the app.',
          ),
        ],
        // Instruct flutter to not put a leading widget automatically
        // see https://api.flutter.dev/flutter/material/AppBar/leading.html
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child:
                  // Step 2: Show loading indicator.

                  CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: smallButtonGap),
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
                        const SizedBox(height: smallButtonGap),
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
                        const SizedBox(height: smallButtonGap),
                        ElevatedButton(
                          child: const Text('Show Private Data'),
                          onPressed: () async {
                            await _showPrivateData(title);
                          },
                        ),
                        const SizedBox(height: smallButtonGap),
                        ElevatedButton(
                          child: const Text('Key Value Table Demo'),
                          onPressed: () async {
                            await _writePrivateData();
                          },
                        ),
                        const SizedBox(height: largeButtonGap),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Local Security Key Management',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              changeKeyPopup(context);
                            },
                            child: const Text('Change Security Key')),
                        const SizedBox(height: smallButtonGap),
                        ElevatedButton(
                          child: const Text('Forget Local Security Key'),
                          onPressed: () async {
                            late String msg;
                            try {
                              await removeMasterPassword();
                              msg = 'Successfully forgot local security key.';
                            } on Exception catch (e) {
                              msg = 'Failed to forget local security key: $e';
                            }
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Notice'),
                                content: Text(msg),
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
                        const SizedBox(height: largeButtonGap),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Solid Server Login Management',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          child: const Text(
                              'Forget Remote Solid Server Login Info'),
                          onPressed: () async {
                            final deleteRes = await deleteLogIn();

                            var deleteMsg = '';

                            if (deleteRes) {
                              deleteMsg =
                                  'Successfully forgot remote solid server login info';
                            } else {
                              deleteMsg =
                                  'Failed to forget login info. Try again in a while';
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
                        const SizedBox(height: smallButtonGap),
                        ElevatedButton(
                            onPressed: () async {
                              await logoutPopup(context, const KeyPod());
                            },
                            child:
                                const Text('Logout From Remote Solid Server')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({String name, String version})>(
        future: getAppNameVersion(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final appName = snapshot.data?.name;
            final title = appName!.isNotEmpty
                ? appName[0].toUpperCase() + appName.substring(1)
                : '';
            return _build(context, title);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
