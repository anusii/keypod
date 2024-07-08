/// A template app to begin a Solid Pod project.
//
// Time-stamp: <Monday 2024-07-08 19:01:58 +1000 Graham Williams>
//
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

import 'package:solidpod/solidpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:keypod/home.dart';
import 'package:keypod/utils/is_desktop.dart';

void main() async {
  // This is the main entry point for the app. The [async] is required because
  // we asynchronously [await] some activity below.

  // Suport placing the new window on top of all other windows on starting up
  // the desktop app.

  if (isDesktop(PlatformWrapper())) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      // We can set various desktop window options here.

      // Setting [alwaysOnTop] here will ensure the app starts on top of other
      // apps on the desktop so that it is visible (otherwise it is often lost
      // below other windows on startup which can be a little disconcerting). We
      // later turn it off as we don't want to force it always on top.

      alwaysOnTop: true,

      // The [title] is used for the window manager's window title.

      title: 'KeyPod - Private Solid Pod for Storing Key-Value Pairs',
    );

    // Once the window manager is ready wet recofigure it a little.

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
    return const MaterialApp(
      title: 'Solid Key Pod',
      home: SelectionArea(
        // Wrap the whole app inside a SelectionArea to ensure we get selectable
        // text where it can be, as a default.

        child: SolidLogin(
          // Wrap the actual home widget within a [SolidLogin].

          // If the app has functionality that does not require access to Pod
          // data then [required] can be `false`. If the user connects to their
          // Pod then we can ensure their session information will be saved. If
          // we aim to save the data to the Pod or view data from the Pod, then
          // if the user did not log in during startup we can call
          // [SolidLoginPopup] to establish the connection at that time. The
          // login token and the security key are (optionally) cached so that
          // the login information is not required every time.

          // For demonstration purposes we do not require a login through the
          // SolidLogin. Our app here will request a login immediately anyhow
          // since it has no functionality without data from the SolidPod.

          required: false,

          title: 'KEY/VALUE SOLID POD',
          image: AssetImage('assets/images/keypod_image.jpg'),
          logo: AssetImage('assets/images/keypod_logo.png'),
          link: 'https://github.com/anusii/keypod/blob/main/README.md',
          infoButtonStyle: InfoButtonStyle(
            tooltip: 'Visit the KeyPod documentation.',
          ),
          loginButtonStyle: LoginButtonStyle(
            background: Colors.lightGreenAccent,
          ),
          child: Home(),
        ),
      ),
    );
  }
}
