/// The root widget for the KeyPod app.
///
/// Time-stamp: <Wednesday 2024-07-10 13:41:48 +1000 Graham Williams>
///
/// Copyright (C) 2024, Software Innovation Institute.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
/// Authors: Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:keypod/home.dart';

/// A widget for the root of the KeyPod app encompassing the Rattle home widget.
///
/// The root widget covers the screen of the app. This widget is stateless as it
/// does not need to manage any state itself.

class KeyPodApp extends StatelessWidget {
  const KeyPodApp({super.key});

  /// Build the root widget as a [MaterialApp] widget, setting up the app theme,
  /// and populating the widget with the Rattle home page widget.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('KeyPod Template App for SolidPod')),
        body: Stack(
          children: [
            // Your main content goes here
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => KeyPodHome(),
                    ),
                  );
                },
                child: const Text('Load Data from your Solid Pod'),
              ),
            ),
          ],
          //KeyPodHome(),
        ),
      ),
    );
  }
}
