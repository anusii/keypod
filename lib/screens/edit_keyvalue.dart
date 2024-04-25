/// A widget to edit key/value pairs and save them in a POD.
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
/// Authors: Dawei Chen

import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:solidpod/solidpod.dart';
import 'package:rdflib/rdflib.dart';

class KeyValueEdit extends StatefulWidget {
  /// Constructor
  const KeyValueEdit(
      {required this.title,
      required this.filePath,
      required this.child,
      this.keyValuePairs,
      super.key});

  final String title;
  final String filePath; // path of file to be saved in PODs
  final Widget child;
  final Map<String, String>? keyValuePairs; // initial key value pairs

  @override
  State<KeyValueEdit> createState() => _KeyValueEditState();
}

class _KeyValueEditState extends State<KeyValueEdit> {
  /// Create a Key for EditableState
  final _editableKey = GlobalKey<EditableState>();
  final regExp = RegExp(r'\s+');
  static const rowKey = 'row'; // key of row index in editedRows
  static const keyStr = 'key';
  static const valStr = 'value';
  final List rows = [];
  final List cols = [
    {'title': 'Key', 'key': keyStr},
    {'title': 'Value', 'key': valStr},
  ];
  final dataMap = <int, ({String key, dynamic value})>{};

  @override
  void initState() {
    super.initState();

    // A column is a {'title': TITLE, 'key': KEY}
    // A row is a {KEY: VALUE}

    // Initialise the rows
    if (widget.keyValuePairs != null) {
      for (final key in (widget.keyValuePairs?.keys.toList() as List)..sort()) {
        rows.add({keyStr: key, valStr: widget.keyValuePairs![key]});
      }
    }

    // Save initial data
    for (var i = 0; i < rows.length; i++) {
      dataMap[i] = (key: rows[i][keyStr], value: rows[i][valStr]);
    }
  }

  // Add a new row using the global key assigined to the Editable widget
  // to access its current state
  void _addNewRow() {
    setState(() {
      _editableKey.currentState?.createRow();
    });
  }

  void _saveEditedRows() {
    final editedRows = _editableKey.currentState?.editedRows as List;
    // print('edited_rows: ${editedRows}');
    // print('#rows: ${_editableKey.currentState?.rowCount}');
    // print('#cols: ${_editableKey.currentState?.columnCount}');
    // print('rows:');
    // print(rows); // edits are not saved in `rows'
    for (final r in editedRows) {
      dataMap[r[rowKey] as int] = (key: r[keyStr] as String, value: r[valStr]);
    }

    print(dataMap);

    // int rowIndex = editedRows.indexWhere(
    //               (element) => element['row'] == index ? true : false);
    //           if (rowIndex != -1) {
    //             widget.onRowSaved!(editedRows[rowIndex]);
    //           } else {
    //             widget.onRowSaved!('no edit');
    //           }
  }

  // Show an alert message
  Future<void> _alert(String msg) async {
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
            ));
  }

  // Get key value pairs
  Future<List<({String key, dynamic value})>?> _getKeyValuePairs() async {
    final rowInd = dataMap.keys.toList()..sort();
    final keys = <String>{};
    final pairs = <({String key, dynamic value})>[];
    for (final i in rowInd) {
      final k = dataMap[i]!.key.trim();
      if (k.isEmpty) {
        await _alert('Invalide key: "$k"');
        return null;
      }
      if (keys.contains(k)) {
        await _alert('Invalide key: Duplicate key "$k"');
        return null;
      }
      if (regExp.hasMatch(k)) {
        await _alert('Invalided key: Whitespace found in key "$k"');
        return null;
      }
      keys.add(k);
      final v = dataMap[i]!.value;
      pairs.add((key: k, value: v));
    }
    return pairs;
  }

  // Convert data in the table to a map
  // Future<Map<String, String>?> _dataToMap() async {
  //   final dataMap = <String, String>{};
  //   for (final row in _editableKey.currentState?.rows as List) {
  //     final k = row['key'] as String;
  //     final v = row['value'] as String;
  //     if (dataMap.containsKey(k)) {
  //       await _alert('Invalide key: Duplicate key "$k"');
  //       return null;
  //     }
  //     if (k.trim().isEmpty) {
  //       await _alert('Invalide key: "$k"');
  //       return null;
  //     }
  //     if (regExp.hasMatch(k)) {
  //       await _alert('Invalided key: Whitespace found in key "$k"');
  //       return null;
  //     }
  //     dataMap[k] = v;
  //   }
  //   return dataMap;
  // }

  Future<void> _saveToPod(BuildContext context) async {
    _saveEditedRows();
    final pairs = await _getKeyValuePairs();
    // final dataMap = await _dataToMap();
    // print(dataMap);
    // if (dataMap != null && dataMap.isNotEmpty) {
    if (dataMap.isNotEmpty) {
      // generate TTL str with dataMap
      final ttlStr = await getTTLStr(pairs!);
      print(ttlStr);
      await writePod(widget.filePath, ttlStr, context, widget.child);
    } else {
      await _alert('No data to submit');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          leadingWidth: 100,
          leading: TextButton.icon(
            onPressed: _addNewRow,
            icon: const Icon(Icons.add),
            label: const Text('Add',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveToPod(context);
                  },
                  child: const Text('Submit',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )),
          ],
        ),
        body: Center(
          child: Editable(
            key: _editableKey,
            columns: cols,
            rows: rows,
            // zebraStripe: false,
            // stripeColor1: Colors.blue[50]!,
            // stripeColor2: Colors.grey[200]!,
            onRowSaved: print,
            onSubmitted: print,
            borderColor: Colors.blueGrey,
            tdStyle: const TextStyle(fontWeight: FontWeight.bold),
            trHeight: 20,
            thStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            thAlignment: TextAlign.center,
            thVertAlignment: CrossAxisAlignment.end,
            thPaddingBottom: 3,
            // showSaveIcon:
            //     false, // do not show the save icon at the right of a row
            // saveIconColor: Colors.black,
            // showCreateButton: false, // do not show the + button at top-left
            tdAlignment: TextAlign.left,
            tdEditableMaxLines: 100, // don't limit and allow data to wrap
            tdPaddingTop: 5,
            tdPaddingBottom: 5,
            tdPaddingLeft: 8,
            tdPaddingRight: 8,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.zero),
          ),
        ));
  }
}
