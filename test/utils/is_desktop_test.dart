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
