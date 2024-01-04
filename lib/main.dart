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
import 'package:keypod/utils/is_desktop.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:solid/solid.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // Remove [debugPrint] messages from production code. Comment this out to have
  // [debugPrint] messages displayed to the console.

  debugPrint = (message, {wrapWidth}) {};

  // Get app version from pubspec.yaml.

  // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp().

  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appVersion = packageInfo.version;

  // Suport window size and top placement for desktop apps.

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

  runApp(KeyPod(appVersion: appVersion));
}

class KeyPod extends StatelessWidget {

  const KeyPod({required this.appVersion, super.key});
  final String appVersion;

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

      home: SolidLogin(
        // Images generated using Bing Image Creator from Designer, powered by
        // DALL-E3.

        image: const AssetImage('assets/images/keypod_image.jpg'),
        logo: const AssetImage('assets/images/keypod_logo.png'),
        title: 'MANAGE YOUR SOLID KEY POD',
        link: 'https://github.com/anusii/keypod',
        version: appVersion,
        child: const Scaffold(body: Text('Key Pod Placeholder')),
      ),
    );
  }
}
