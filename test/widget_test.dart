// This is a basic Flutter widget test for Noor-ul-Iman Islamic App
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nooruliman/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that app launched successfully
    // This test just ensures app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);

    // Wait for splash screen timer (3 seconds) plus navigation
    await tester.pump(const Duration(seconds: 3));

    // Pump frames to complete any pending animations/transitions
    await tester.pump();
    await tester.pump();
  });
}
