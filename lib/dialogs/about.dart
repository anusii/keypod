/// An About dialog for the app.
///
// Time-stamp: <Thursday 2024-06-27 15:39:05 +1000 Graham Williams>
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
/// Authors: Kevin Wang, Graham Williams

library;

import 'package:solidpod/solidpod.dart';

import 'package:flutter/material.dart';

Future<void> aboutDialog(BuildContext context) async {
  final appInfo = await getAppNameVersion();

  if (context.mounted) {
    showAboutDialog(
      context: context,
      applicationLegalese: '© 2024 Software Innovation Institute ANU',
      applicationIcon: Image.asset(
        'assets/images/keypod_logo.png',
        width: 100,
        height: 100,
      ),
      applicationName: appInfo.name,
      applicationVersion: appInfo.version,
      children: [
        const SizedBox(
          width: 300, // Limit the width.
          child: SelectableText('\nA key-value pair manager.\n\n'
              'Key Pod is an app for managing your secure and private'
              ' key-value data in your Solid Pod. The key-value pairs'
              ' can store any kind of data, indexed by the key.\n\n'
              'The app is written in Flutter and the open source code'
              ' is available from github at https://github.com/anusii/keypod.'
              ' You can try it out online at https://keypod.solidcommunity.au.\n\n'
              'The concept for the app and images were generated by'
              ' large language models.\n\n'
              'Authors: Anuska Vidanage, Graham Williams, Jess Moore, Zheyuan Xu,'
              ' Kevin Wang, Ninad Bhat, Dawei Chen.'),
        ),
      ],
    );
  }
}
