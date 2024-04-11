/// about dialog for the app
///
// Time-stamp: <Tuesday 2024-03-26 06:56:45 +1100 Graham Williams>
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
/// Authors: Kevin Wang
library;

import 'package:flutter/material.dart';

void showAppAboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationIcon:
        const ImageIcon(AssetImage('assets/images/keypod_logo.png')),
    children: const [
      SelectableText('A key-value pair manager.\n\n'
          'Key Pod is an app for managing your secure and private'
          ' key-value data in your Solid Pod. The key-value pairs'
          ' can store any kind of data, indexed by the key.\n\n'
          'The app is written in Flutter and the open source code'
          ' is available from github at https://github.com/anusii/keypod.'
          ' You can try it out online at https://keypod.solidcommunity.au.\n\n'
          'The concept for the app and images were generated by'
          ' large language models.\n\n'
          'Authors: Graham Williams, Zheyuan Xu, Anuska Vidanage,'
          ' Kevin Wang, Ninad Bhat, Dawei Chen.'),
    ],
  );
}
