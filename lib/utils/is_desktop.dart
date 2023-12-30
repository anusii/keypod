/// Check if we are running a desktop (and not a browser).
///
/// Copyright (C) 2024, Software Innovation Institute
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Wednesday 2023-12-27 16:56:13 +1100 Graham Williams>
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

import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart' show Platform;

bool isDesktop(PlatformWrapper platformWrapper) {
  /// platformWrapper: PlatformWrapper class is passed in to allow mocking for testing.
  /// Returns true if running on Linux, macOS or Windows.

  if (platformWrapper.isWeb) {
    return false;
  }

  return platformWrapper.isLinux ||
      platformWrapper.isMacOS ||
      platformWrapper.isWindows;
}

class PlatformWrapper {
  /// Wraps the Platform class to allow mocking for testing.
  bool get isLinux => Platform.isLinux;
  bool get isMacOS => Platform.isMacOS;
  bool get isWeb => kIsWeb;
  bool get isWindows => Platform.isWindows;
}
