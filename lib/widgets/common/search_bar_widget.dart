import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import 'app_card.dart';

/// Reusable search bar widget with voice search and waveform animation.
/// Features:
/// - Text search with real-time filtering
/// - Voice search with mic button
/// - Waveform animation when listening
/// - Auto dark mode support
///
/// Example usage:
/// ```dart
/// SearchBarWidget(
///   controller: _searchController,
///   hintText: 'Search...',
///   onChanged: (value) => _filterItems(value),
///   enableVoiceSearch: true,
/// )
/// ```
class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool enableVoiceSearch;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.enableVoiceSearch = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    if (widget.enableVoiceSearch) {
      _initSpeech();
    }
  }

  Future<void> _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      debugPrint('Speech init error: $e');
    }
  }

  void _onMicPressed() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.errorMsg}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
    );

    if (available) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              widget.controller.text = result.recognizedWords;
              _isListening = false;
            });
            widget.onChanged?.call(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Speech recognition not available. Please enable microphone permission.',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Widget _buildWaveformAnimation() {
    return SizedBox(
      width: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeInOut,
            width: 3,
            height: _isListening ? (12 + (index % 2) * 8) : 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: EdgeInsets.zero,
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          setState(() {}); // Rebuild to show/hide clear button
          widget.onChanged?.call(value);
        },
        textInputAction: TextInputAction.search,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: _isListening ? 'Listening...' : widget.hintText,
          hintStyle: TextStyle(
            color: _isListening
                ? AppColors.primary
                : (isDark ? AppColors.darkTextSecondary : AppColors.textHint),
          ),
          prefixIcon: _isListening
              ? _buildWaveformAnimation()
              : const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: widget.enableVoiceSearch
              ? Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.red : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: _onMicPressed,
                    icon: Icon(
                      _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                )
              : (widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      onPressed: () {
                        widget.controller.clear();
                        setState(() {});
                        widget.onClear?.call();
                      },
                    )
                  : null),
          filled: true,
          fillColor: isDark ? AppColors.darkCard : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
            vertical: AppDimens.paddingMedium,
          ),
        ),
      ),
    );
  }
}
