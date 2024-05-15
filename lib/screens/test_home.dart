/// Home page after user creating account.
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
///
/// Authors: Zheyuan Xu, Anushka Vidanage, Kevin Wang, Dawei Chen, Graham Williams

// TODO 20240411 gjw WHY THE IGNORE? EXPLAIN HERE

// ignore_for_file: use_build_context_synchronously

library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keypod/main.dart';
import 'package:keypod/screens/about_dialog.dart';
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

class TestHome extends StatefulWidget {
  /// Initialise widget variables

  const TestHome({super.key});

  @override
  TestHomeState createState() => TestHomeState();
}

class TestHomeState extends State<TestHome>
    with SingleTickerProviderStateMixin {
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
        const TestHome(),
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

      final fileContent = await readPod(filePath, context, const TestHome());
      final pairs = fileContent == null ? null : await parseTTLStr(fileContent);

      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => KeyValueEdit(
                  title: 'Key Value Pair Editor',
                  fileName: fileName,
                  keyValuePairs: pairs,
                  child: const TestHome())));
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
                              // await removeMasterPassword();
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
