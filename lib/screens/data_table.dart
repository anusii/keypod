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

  bool _isDataModified = false; // Track if data has been modified

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
        if (dataMap[index]!['key'] != newKey) {
          dataMap[index]!['key'] = newKey;
          _isDataModified = true; // Mark data as modified
        }
        dataMap[index]!['key'] = newKey;
        print("dataMap: $dataMap");
      }
    });
  }

  void _updateRowValue(int index, String newValue) {
    setState(() {
      if (dataMap[index]!['value'] != newValue) {
        dataMap[index]!['value'] = newValue;
        _isDataModified = true; // Mark data as modified
      }
    });
  }

  void _deleteRow(int index) {
    setState(() {
      dataMap.remove(index);
      _isDataModified = true; // Mark data as modified
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

  // Save data to PODs
  Future<bool> _saveToPod(BuildContext context) async {
    setState(() {
      // Begin loading.

      _isLoading = true;
    });

    final pairs = convertDataMapToListOfPairs(dataMap);

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
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewRow,
          ),
          ElevatedButton(
            onPressed: _isDataModified
                ? () async {
                    setState(() {
                      _isLoading = true; // Start loading
                    });
                    final saved = await _saveToPod(context);
                    if (saved) {
                      setState(() {
                        _isDataModified = false; // Reset modification flag
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.child));
                    }
                    setState(() {
                      _isLoading = false; // Stop loading
                    });
                  }
                : null, // Disable button if data is not modified
            child: const Text('Save',
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors
                        .grey.shade300; // Light grey color when disabled
                  return Theme.of(context).colorScheme.primary; // Regular color
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.black; // Text color when disabled
                  return Colors.white; // Text color when enabled
                },
              ),
            ),
          ),
          SizedBox(width: 10),
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
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Align children to the center
                children: <Widget>[
                  CircularProgressIndicator(), // Loading spinner
                  SizedBox(height: 20), // Space between spinner and text
                  Text("Saving in Progress",
                      style: TextStyle(fontSize: 16)), // Text message
                ],
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 12.0,
                  horizontalMargin: 10.0,
                  headingRowColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.8); // Header background color
                  }),
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
                              text: dataMap[index]!['key'] as String),
                          onChanged: (newKey) => _updateRowKey(index, newKey),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        )),
                        DataCell(TextField(
                          controller: TextEditingController(
                              text: dataMap[index]!['value'] as String),
                          onChanged: (newValue) =>
                              _updateRowValue(index, newValue),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        )),
                        DataCell(_actionCell(index)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  Widget _customCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: TextStyle(fontSize: 14)),
    );
  }

  Widget _actionCell(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // IconButton(
        //   icon: Icon(Icons.edit, color: Colors.blue),
        //   onPressed: () {
        //     // Add your edit action
        //   },
        // ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
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
