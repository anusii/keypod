/// A data table to edit key/value pairs and save them in a POD.
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
/// Authors: Kevin Wang
library;

import 'package:flutter/material.dart';
import 'package:keypod/utils/rdf.dart';
import 'package:solidpod/solidpod.dart';

class KeyValueTable extends StatefulWidget {
  final String title;
  final String fileName;
  final Widget child;
  final List<Map<String, dynamic>>? keyValuePairs;

  const KeyValueTable({
    Key? key,
    required this.title,
    required this.fileName,
    required this.child,
    this.keyValuePairs,
  }) : super(key: key);

  @override
  State<KeyValueTable> createState() => _KeyValueTableState();
}

class _KeyValueTableState extends State<KeyValueTable> {
  // Loading indicator for data submission.

  bool _isLoading = false;
  Map<int, Map<String, dynamic>> dataMap = {};
  // Track if data has been modified.

  bool _isDataModified = false;

  // Map to hold the TextEditingController for each key and value.
  Map<int, TextEditingController> keyControllers = {};
  Map<int, TextEditingController> valueControllers = {};
  @override
  void initState() {
    super.initState();
    if (widget.keyValuePairs != null) {
      int i = 0;
      for (var pair in widget.keyValuePairs!) {
        var keyController = TextEditingController(text: pair['key'] as String);
        var valueController =
            TextEditingController(text: pair['value'] as String);
        keyControllers[i] = keyController;
        valueControllers[i] = valueController;
        dataMap[i++] = {'key': pair['key'], 'value': pair['value']};
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.
    keyControllers.forEach((key, controller) {
      controller.dispose();
    });
    valueControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _addNewRow() {
    setState(() {
      int newIndex = dataMap.length;
      dataMap[newIndex] = {'key': '', 'value': ''};
      keyControllers[newIndex] = TextEditingController();
      valueControllers[newIndex] = TextEditingController();
    });
  }

  void _updateRowKey(int index, String newKey) {
    if (dataMap[index]!['key'] != newKey) {
      setState(() {
        dataMap[index]!['key'] = newKey;
        _isDataModified = true;
      });
    }
  }

  void _updateRowValue(int index, String newValue) {
    if (dataMap[index]!['value'] != newValue) {
      setState(() {
        dataMap[index]!['value'] = newValue;
        _isDataModified = true;
      });
    }
  }

  void _deleteRow(int index) {
    setState(() {
      dataMap.remove(index);
      keyControllers[index]?.dispose();
      valueControllers[index]?.dispose();
      keyControllers.remove(index);
      valueControllers.remove(index);
      _isDataModified = true;
    });
  }

  Widget buildDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Key')),
        DataColumn(label: Text('Value')),
        DataColumn(label: Text('Actions')),
      ],
      rows: dataMap.keys.map((index) {
        return DataRow(cells: [
          DataCell(TextField(
            controller: keyControllers[index],
            onChanged: (newKey) => _updateRowKey(index, newKey),
            decoration: const InputDecoration(border: InputBorder.none),
          )),
          DataCell(TextField(
            controller: valueControllers[index],
            onChanged: (newValue) => _updateRowValue(index, newValue),
            decoration: const InputDecoration(border: InputBorder.none),
          )),
          DataCell(_actionCell(index)),
        ]);
      }).toList(),
    );
  }

  // Show an alert message
  Future<void> _alert(String msg, [String title = 'Notice']) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(msg),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  // Save data to PODs
  Future<bool> _saveToPod(BuildContext context) async {
    setState(() {
      // Begin loading.

      _isLoading = true;
    });

    final pairs = convertDataMapToListOfPairs(dataMap);

    try {
      // Generate TTL str with dataMap.

      final ttlStr = await genTTLStrNew(pairs);

      // Write to POD.

      await writePod(widget.fileName, ttlStr, context, widget.child);

      await _alert('Successfully saved ${dataMap.length} key-value pairs'
          ' to "${widget.fileName}" in PODs');
      return true;
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
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewRow,
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _isDataModified
                ? () async {
                    setState(() {
                      // Start loading.

                      _isLoading = true;
                    });
                    final saved = await _saveToPod(context);
                    if (saved) {
                      setState(() {
                        // Reset modification flag.

                        _isDataModified = false;
                      });
                    }
                    setState(() {
                      // Stop loading.

                      _isLoading = false;
                    });
                  }
                : null,
            style: activeButtonStyle(
                context), // Disable button if data is not modified
            child: const Text('Save',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => widget.child));
            },
            style: activeButtonStyle(context),
            child: const Text('Go back',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Saving in Progress', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : Center(
              child: Container(
                // 3/4 of screen width.

                width: MediaQuery.of(context).size.width * 0.75,
                // Light grey thicker border.

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 2.0),
                  // Rounded corners.

                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: buildDataTable(),
                  ),
                ),
              ),
            ),
    );
  }

  ButtonStyle activeButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            // Light grey color when disabled.

            return Colors.grey.shade300;
          }

          // Regular color.

          return Colors.lightBlue;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            // Text color when disabled.

            return Colors.black;
          }

          // Text color when enabled.

          return Colors.white;
        },
      ),
    );
  }

  Widget _customCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _actionCell(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteRow(index),
        ),
      ],
    );
  }
}

class KeyValuePair {
  String key;
  dynamic value;

  KeyValuePair({required this.key, this.value});

  // match the exact structure which is  expected to pass to genTTLStr.

  get getKey => key;
  get getValue => value;
}

// Function to convert Map<int, Map<String, dynamic>> to List<KeyValuePair>
List<KeyValuePair> convertDataMapToListOfPairs(
    Map<int, Map<String, dynamic>> dataMap) {
  return dataMap.values
      .map(
          (map) => KeyValuePair(key: map['key'] as String, value: map['value']))
      .toList();
}
