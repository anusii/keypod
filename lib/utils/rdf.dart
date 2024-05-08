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
library;

import 'package:rdflib/rdflib.dart';

import 'package:solidpod/solidpod.dart' show getWebId;

// Namespace for keys
const String appTerms = 'https://solidcommunity.au/predicates/terms#';

/// Serialise key/value pairs [keyValuePairs] in TTL format where
/// Subject: Web ID
/// Predicate: Key
/// Object: Value

Future<String> genTTLStr(
    List<({String key, dynamic value})> keyValuePairs) async {
  assert(keyValuePairs.isNotEmpty);
  assert({for (final p in keyValuePairs) p.key}.length ==
      keyValuePairs.length); // No duplicate keys
  final webId = await getWebId();
  assert(webId != null);
  final g = Graph();
  final f = URIRef(webId!);
  final ns = Namespace(ns: appTerms);

  for (final p in keyValuePairs) {
    g.addTripleToGroups(f, ns.withAttr(p.key), p.value);
  }

  g.serialize(abbr: 'short');

  return g.serializedString;
}

/// Parse TTL string [ttlStr] and returns the key-value pairs from triples where
/// Subject: Web ID
/// Predicate: Key
/// Object: Value

Future<List<({String key, dynamic value})>> parseTTLStr(String ttlStr) async {
  assert(ttlStr.isNotEmpty);
  final g = Graph();
  g.parseTurtle(ttlStr);
  final keys = <String>{};
  final pairs = <({String key, dynamic value})>[];
  final webId = await getWebId();
  assert(webId != null);
  String extract(String str) => str.contains('#') ? str.split('#')[1] : str;
  for (final t in g.triples) {
    final sub = t.sub.value as String;
    if (sub == webId) {
      final pre = extract(t.pre.value as String);
      final obj = extract(t.obj.value as String);
      assert(!keys.contains(pre));
      keys.add(pre);
      pairs.add((key: pre, value: obj));
    }
  }
  return pairs;
}
