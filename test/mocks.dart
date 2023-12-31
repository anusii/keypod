/// Functions to auto generate mocks for unit tests using Mockito.
///
/// Copyright (C) 2024, Software Innovation Institute
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2023-12-31 12:24:25 +1100 Graham Williams>
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

import 'package:keypod/utils/is_desktop.dart';
import 'package:mockito/annotations.dart';

/// This file is used to generate mocks for unit tests.
/// See https://docs.flutter.dev/cookbook/testing/unit/mocking
/// for more information.
@GenerateMocks([PlatformWrapper])
void main() {}
