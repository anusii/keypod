/// A widget to view private data in a POD.
///
// Time-stamp: <Thursday 2024-04-11 21:57:36 +1000 Graham Williams>
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
/// Authors: Anushka Vidanage

library;

import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart' show getFileContent;

import 'package:keypod/screens/home.dart';

/// A widget to show the user all the encryption keys stored in their POD.

class ViewKeys extends StatefulWidget {
  /// Constructor for ShowKeys widget

  const ViewKeys({
    required this.keyInfo,
    required this.title,
    super.key,
  });

  // Name of the app
  // final String appName;

  /// Data of the key file
  final String keyInfo;

  // Title of the page
  final String title;

  @override
  State<ViewKeys> createState() => _ViewKeysState();
}

class _ViewKeysState extends State<ViewKeys> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: loadedScreen(widget.keyInfo));
  }

  @override
  void initState() {
    super.initState();
  }

  Widget loadedScreen(String keyData) {
    final encFileData = getFileContent(keyData);

    //TODO av-20240319: Need to get the encryption key
    // to decrypt the private key value

    // encKey = secureStorage.read(key: 'key')

    // final keyMaster = Key.fromUtf8(encKey);
    // final ivInd = IV.fromBase64(encFileData['iv'][1] as String);
    // final encrypterKey =
    //     Encrypter(AES(keyMaster, mode: AESMode.cbc));

    // final eccKey = Encrypted.from64(medFileKey);
    // final keyIndPlain = encrypterKey.decrypt(eccKey, iv: ivInd);

    final dataRows = encFileData.entries.map((entry) {
      return DataRow(cells: [
        DataCell(Text(
          entry.key as String,
          style: const TextStyle(
            fontSize: 12,
          ),
        )),
        DataCell(SizedBox(
            width: 600,
            child: Text(
              entry.value[1] as String,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
              ),
            ))),
      ]);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DataTable(
                columnSpacing: 30.0,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Parameter',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Value',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: dataRows),
            // [
            //   DataRow(cells: [
            //     const DataCell(Text(
            //       'Encryption key verification',
            //       style: TextStyle(
            //         fontSize: 12,
            //       ),
            //     )),
            //     DataCell(Text(
            //       encFileData['encKey'][1] as String,
            //       style: const TextStyle(
            //         fontSize: 12,
            //       ),
            //     )),
            //   ]),
            //   DataRow(cells: [
            //     const DataCell(Text(
            //       'Private key',
            //       style: TextStyle(
            //         fontSize: 12,
            //       ),
            //     )),
            //     DataCell(SizedBox(
            //       width: 600,
            //       child: Text(
            //         encFileData['prvKey'][1] as String,
            //         overflow: TextOverflow.ellipsis,
            //         style: const TextStyle(
            //           fontSize: 12,
            //         ),
            //       ),
            //     )),
            //   ])
            // ]),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              child: const Text('Go back'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
