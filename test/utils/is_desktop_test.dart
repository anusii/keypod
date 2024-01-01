/// Include unit tests for the isDesktop function.
///
/// Copyright (C) 2024, Software Innovation Institute
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-12-31 12:21:24 +1100 Graham Williams>
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
/// Authors: Ninad Bhat
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:keypod/utils/is_desktop.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart'; // Mockito generated file

void main() {
  MockPlatformWrapper? mockPlatformWrapper;

  setUp(() {
    // Initialize the mock before each test
    mockPlatformWrapper = MockPlatformWrapper();
  });

  void mockPlatform(
      {bool isWeb = false,
      bool isLinux = false,
      bool isMacOS = false,
      bool isWindows = false}) {
    // Utility function to mock platform properties
    when(mockPlatformWrapper!.isWeb).thenReturn(isWeb);
    when(mockPlatformWrapper!.isLinux).thenReturn(isLinux);
    when(mockPlatformWrapper!.isMacOS).thenReturn(isMacOS);
    when(mockPlatformWrapper!.isWindows).thenReturn(isWindows);
  }

  test('returns false when running in a web browser', () {
    mockPlatform(isWeb: true);
    expect(isDesktop(mockPlatformWrapper!), false);
  });

  test('returns false when running on iOS and Android', () {
    mockPlatform();
    expect(isDesktop(mockPlatformWrapper!), false);
  });

  test('returns true when running on Linux', () {
    mockPlatform(isLinux: true);
    expect(isDesktop(mockPlatformWrapper!), true);
  });

  test('returns true when running on macOS', () {
    mockPlatform(isMacOS: true);
    expect(isDesktop(mockPlatformWrapper!), true);
  });

  test('returns true when running on Windows', () {
    mockPlatform(isWindows: true);
    expect(isDesktop(mockPlatformWrapper!), true);
  });
}
