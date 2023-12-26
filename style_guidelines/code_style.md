# Flutter Code Style Guide

This documents highlights the Flutter code style guidelines that we follow and SII specific additions to the guidelines. For more information on  code style guidelines, see [Flutter Style](https://survivor.togaware.com/gnulinux/flutter-style.html), [Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo ) and [Dartstyle guide](https://dart.dev/effective-dart).

## Usefull plugins
1. [Dart Style](https://pub.dev/packages/dart_style) - A formatter for Dart code.

## SII Specific Additions
### 1. One class per file
Each class should be in its own file. The name of the file should match the name of the class.

### 2. TODO in code
If TODOs are left in the code, they should be included in the pull request description and corresponding issue should be created. Write issue number along with TODO, for example `// TODO (Issue 1234)`. This will ensure that they are not forgotten.

### 3. Avoid ignoring errors
Avoid ignoring errors. If you need to ignore an error, add a comment explaining why. For example, `// ignore: deprecated_member_use`.

### 4. Ensure every file has license header
Every file should have a license header. Add your name to the list of authors if you make a contribution to the file.

## Flutter Code Style Guidelines
### 1. Naming

- Classes, enum types, typedefs, and type parameters  should capitalize the first letter of each word. For example, `RadialGradient` and `HttpRequest`.

- Packages, directories, and source files should use lowercase_with_underscores style. For example, `http_parser`, `lib`, and `analysis_options.yaml`.

For other suggestions on naming, see the [Dart style guide](https://dart.dev/effective-dart/style).

### 3. Maximum line length of 80 characters
Aim for a maximum line length of roughly 80 characters, but prefer going over if breaking the line would make it less readable, or if it would make the line less consistent with other nearby lines. Prefer avoiding line breaks after assignment operators.



