/// A basic template app to begin a Solid POD project.
///
// Time-stamp: <Wednesday 2024-01-03 19:24:44 +1100 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:solid/solid.dart';
import 'package:window_manager/window_manager.dart';

import 'package:keypod/utils/is_desktop.dart';

void main() async {
  // Remove [debugPrint] messages from production code. Comment this out to have
  // [debugPrint] messages displayed to the console.

  debugPrint = (message, {wrapWidth}) {};

  // For desktop versions of the app we may want to change the default window
  // size and whether the app starts on top of other windows on the desktop
  // rather than burried as seems the default.
  //
  // We use PlatformWrapper(), passed into isDesktop(), to allow mocking for
  // testing.

  if (isDesktop(PlatformWrapper())) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      // Setting [alwaysOnTop] here will ensure the app starts on top of other
      // apps on the desktop so that it is visible. We later turn it of as we
      // don't want to force it always on top.

      alwaysOnTop: true,

      // The [title] is used for the window manager's window title.

      title: 'KeyPod - A private POD for storing Key Value pairs',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  // Ready to run the app.

  runApp(const KeyPod());
}

class KeyPod extends StatelessWidget {
  const KeyPod({super.key});

  // This widget is the root of our application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Key POD',
      theme: ThemeData(
        // This is the theme of our application.

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Build the app's home widget.
      //
      // Because our app requires access to the data stored within the user's
      // POD for any of its functionality, we wrap the app's home within the
      // [SolidLogin] widget to initiate the user's authentication with the
      // Solid server. The SolidLogin widget can be tuned to suit the look and
      // feel of the app with appropraite login images and logo.

      home: const SolidLogin(
        image: AssetImage('assets/images/keypod_image.jpg'),
        logo: AssetImage('assets/images/keypod_logo.png'),
        title: 'MANAGE YOUR SOLID KEY POD',
        link: 'https://github.com/anusii/keypod',
        child: Scaffold(body: Text('Key Pod Placeholder')),
      ),
    );
  }
}
