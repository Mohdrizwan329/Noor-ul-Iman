/// A wrapper class for multilingual text content
/// Supports English, Urdu, Hindi, and Arabic languages
class MultilingualText {
  final String en;
  final String ur;
  final String hi;
  final String ar;

  const MultilingualText({
    required this.en,
    this.ur = '',
    this.hi = '',
    this.ar = '',
  });

  /// Create an empty MultilingualText
  const MultilingualText.empty()
      : en = '',
        ur = '',
        hi = '',
        ar = '';

  /// Create from JSON map
  factory MultilingualText.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MultilingualText.empty();
    return MultilingualText(
      en: json['en'] as String? ?? '',
      ur: json['ur'] as String? ?? '',
      hi: json['hi'] as String? ?? '',
      ar: json['ar'] as String? ?? '',
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() => {
        'en': en,
        'ur': ur,
        'hi': hi,
        'ar': ar,
      };

  /// Get text for specified language code with fallback to English
  String get(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'ur':
      case 'urdu':
        return ur.isNotEmpty ? ur : en;
      case 'hi':
      case 'hindi':
        return hi.isNotEmpty ? hi : en;
      case 'ar':
      case 'arabic':
        return ar.isNotEmpty ? ar : en;
      case 'en':
      case 'english':
      default:
        return en;
    }
  }

  /// Check if text is empty for all languages
  bool get isEmpty => en.isEmpty && ur.isEmpty && hi.isEmpty && ar.isEmpty;

  /// Check if text is not empty for at least one language
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => en;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultilingualText &&
          runtimeType == other.runtimeType &&
          en == other.en &&
          ur == other.ur &&
          hi == other.hi &&
          ar == other.ar;

  @override
  int get hashCode => en.hashCode ^ ur.hashCode ^ hi.hashCode ^ ar.hashCode;

  /// Create a copy with updated values
  MultilingualText copyWith({
    String? en,
    String? ur,
    String? hi,
    String? ar,
  }) {
    return MultilingualText(
      en: en ?? this.en,
      ur: ur ?? this.ur,
      hi: hi ?? this.hi,
      ar: ar ?? this.ar,
    );
  }
}
