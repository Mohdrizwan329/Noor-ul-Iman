import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Utility class for common action helpers like share, copy, save.
/// Centralizes repeated action logic across the app.
///
/// Example usage:
/// ```dart
/// // Share text
/// await ActionHelpers.shareText('Hello World', subject: 'Greeting');
///
/// // Copy to clipboard
/// await ActionHelpers.copyToClipboard(context, 'Text to copy');
///
/// // Save as file
/// await ActionHelpers.saveAsFile('File content', 'myfile.txt');
/// ```
class ActionHelpers {
  /// Share text content with optional subject
  /// Uses the native share dialog on the device
  static Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (e) {
      debugPrint('Error sharing text: $e');
    }
  }

  /// Copy text to clipboard and show a snackbar confirmation
  ///
  /// Parameters:
  /// - context: BuildContext for showing snackbar
  /// - text: Text to copy to clipboard
  /// - successMessage: Optional custom success message (default: 'Copied to clipboard')
  static Future<void> copyToClipboard(
    BuildContext context,
    String text, {
    String? successMessage,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage ?? 'Copied to clipboard'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error copying to clipboard: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to copy'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Save content as a text file to device storage
  ///
  /// Parameters:
  /// - content: Text content to save
  /// - filename: Name of the file (e.g., 'myfile.txt')
  ///
  /// Returns: File path if successful, null otherwise
  static Future<String?> saveAsFile(String content, String filename) async {
    try {
      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      // Write the file
      await file.writeAsString(content);

      debugPrint('File saved: ${file.path}');
      return file.path;
    } catch (e) {
      debugPrint('Error saving file: $e');
      return null;
    }
  }

  /// Copy formatted text with Arabic and translation
  /// Useful for Quran, Hadith, Dua cards
  static Future<void> copyFormattedContent(
    BuildContext context, {
    required String arabicText,
    String? translation,
    String? reference,
    String? title,
  }) async {
    final buffer = StringBuffer();

    if (title != null) {
      buffer.writeln(title);
      buffer.writeln();
    }

    if (reference != null) {
      buffer.writeln('Reference: $reference');
      buffer.writeln();
    }

    buffer.writeln(arabicText);

    if (translation != null && translation.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Translation:');
      buffer.writeln(translation);
    }

    buffer.writeln();
    buffer.writeln('Shared from Noor-ul-Iman Islamic App');

    await copyToClipboard(context, buffer.toString());
  }

  /// Share formatted text with Arabic and translation
  /// Useful for Quran, Hadith, Dua cards
  static Future<void> shareFormattedContent({
    required String arabicText,
    String? translation,
    String? reference,
    String? title,
  }) async {
    final buffer = StringBuffer();

    if (title != null) {
      buffer.writeln(title);
      buffer.writeln();
    }

    if (reference != null) {
      buffer.writeln('Reference: $reference');
      buffer.writeln();
    }

    buffer.writeln(arabicText);

    if (translation != null && translation.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Translation:');
      buffer.writeln(translation);
    }

    buffer.writeln();
    buffer.writeln('Shared from Noor-ul-Iman Islamic App');

    await shareText(buffer.toString(), subject: title);
  }
}
