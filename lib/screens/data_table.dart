import 'package:flutter/material.dart';
import 'package:keypod/utils/rdf.dart';
import 'package:solidpod/solidpod.dart';

class KeyValueTable extends StatefulWidget {
  final String title;
  final String fileName;
  final Widget child;
  final List<Map<String, dynamic>>? keyValuePairs; // Added this line

  const KeyValueTable({
    Key? key,
    required this.title,
    required this.fileName,
    required this.child,
    this.keyValuePairs, // Initialize this in the constructor
  }) : super(key: key);

  @override
  State<KeyValueTable> createState() => _KeyValueTableState();
}

class _KeyValueTableState extends State<KeyValueTable> {
  // List<Map<String, dynamic>> rows = [];
  bool _isLoading = false; // Loading indicator for data submission
  Map<int, Map<String, dynamic>> dataMap = {};
  static const rowKey = 'row'; // key of row index in editedRows
  static const keyStr = 'key';
  static const valStr = 'value';
  final regExp = RegExp(r'\s+');

  @override
  void initState() {
    super.initState();
    print("keyValuePairs: ${widget.keyValuePairs}");
    if (widget.keyValuePairs != null) {
      int i = 0;
      for (var pair in widget.keyValuePairs!) {
        dataMap[i++] = {'key': pair['key'], 'value': pair['value']};
      }
    }
  }

  void _addNewRow() {
    setState(() {
      int newIndex = dataMap.length;
      dataMap[newIndex] = {'key': '', 'value': ''};
    });
  }

  void _updateRowKey(int index, String newKey) {
    setState(() {
      if (dataMap.values.any((row) =>
          row['key'] == newKey &&
          dataMap.keys.firstWhere((k) => dataMap[k] == row) != index)) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Key must be unique."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        dataMap[index]!['key'] = newKey;
        print("dataMap: $dataMap");
      }
    });
  }

  void _updateRowValue(int index, String newValue) {
    setState(() {
      dataMap[index]!['value'] = newValue;
      print("dataMap: $dataMap");
    });
  }

  void _deleteRow(int index) {
    setState(() {
      dataMap.remove(index);
      print("dataMap: $dataMap");
    });
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

// Get key value pairs
  Future<List<Map<String, dynamic>>?> _getKeyValuePairs() async {
    final rowInd = dataMap.keys.toList()..sort();
    final keys = <String>{};
    final pairs = <Map<String, dynamic>>[];
    for (final i in rowInd) {
      // Ensure 'k' is treated as a String explicitly
      final String k = dataMap[i]!['key'].trim() as String;

      if (k.isEmpty) {
        await _alert('Invalid key: "$k"');
        return null;
      }
      if (keys.contains(k)) {
        await _alert('Invalid key: Duplicate key "$k"');
        return null;
      }
      // As 'k' is explicitly declared as String, no need for additional casting here
      if (regExp.hasMatch(k)) {
        await _alert('Invalid key: Whitespace found in key "$k"');
        return null;
      }

      keys.add(k);
      final v = dataMap[i]!['value']; // Assume this is correctly a dynamic type
      pairs.add({'key': k, 'value': v});
    }

    return pairs;
  }

  // Save data to PODs
  Future<bool> _saveToPod(BuildContext context) async {
    // final saved = _saveEditedRows();
    // if (!saved) {
    //   await _alert('Data not changed!');
    //   return false;
    // }
    // final pairs = await _getKeyValuePairs();
    // List<MapEntry<String, dynamic>> tupleList =
    //     pairs.map((map) => MapEntry(map['key'], map['value'])).toList();

    // if (dataMap.isEmpty) {
    //   await _alert('No data to submit');
    //   return false;
    // }

    setState(() {
      // Begin loading.

      _isLoading = true;
    });

    List<KeyValuePair> pairs = convertDataMapToListOfPairs(dataMap);

    try {
      // Generate TTL str with dataMap
      final ttlStr = await genTTLStrNew(pairs);

      // Write to POD
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewRow,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              setState(() {
                _isLoading = true; // Start loading
              });
              final saved = await _saveToPod(context);
              if (saved) {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => widget.child));
              }
              setState(() {
                _isLoading = false; // Stop loading
              });
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => widget.child));
              },
              child: const Text('Go back',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
              // Show data table if not loading
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Key')),
                  DataColumn(label: Text('Value')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: dataMap.keys.map((index) {
                  return DataRow(
                    cells: [
                      DataCell(TextField(
                        controller: TextEditingController(
                            text: dataMap[index]!['key'] as String?),
                        onChanged: (newKey) => _updateRowKey(index, newKey),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      )),
                      DataCell(TextField(
                        controller: TextEditingController(
                            text: dataMap[index]!['value'] as String?),
                        onChanged: (newValue) =>
                            _updateRowValue(index, newValue),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      )),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteRow(index),
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class KeyValuePair {
  String key;
  dynamic value;

  KeyValuePair({required this.key, this.value});

  // Optionally, to match the exact structure you might be expected to pass to genTTLStr
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
