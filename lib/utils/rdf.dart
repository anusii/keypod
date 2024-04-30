/// Common utilities for working on RDF data.
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

import 'package:rdflib/rdflib.dart';

import 'package:solidpod/solidpod.dart' show getWebId;

// Namespace for keys
const String appTerms = 'https://solidcommunity.au/predicates/terms#';

/// Save key/value pairs in TTL format

Future<String> getTTLStr(
    List<({String key, dynamic value})> keyValuePairs) async {
  assert(keyValuePairs.isNotEmpty);
  assert({for (var p in keyValuePairs) p.key}.length ==
      keyValuePairs.length); // No duplicate keys
  final webId = await getWebId();
  assert(webId != null);
  final g = Graph();
  final f = URIRef(webId!);
  final ns = Namespace(ns: appTerms);

  for (final p in keyValuePairs) {
    g.addTripleToGroups(f, ns.withAttr(p.key), p.value);
  }

  g.serialize(format: 'ttl', abbr: 'short');

  return g.serializedString;
}
