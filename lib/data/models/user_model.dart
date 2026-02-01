import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String? name; // Default name (for backward compatibility)
  final String? nameEnglish;
  final String? nameUrdu;
  final String? nameHindi;
  final String? nameArabic;
  final String? profileImagePath;
  final String? location;
  final String? preferredLanguage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.nameEnglish,
    this.nameUrdu,
    this.nameHindi,
    this.nameArabic,
    this.profileImagePath,
    this.location,
    this.preferredLanguage,
    required this.createdAt,
    this.updatedAt,
  });

  // Create UserModel from Firebase User
  factory UserModel.fromFirebaseUser(
    User user, {
    String? displayName,
    String? language,
    String? nameEnglish,
    String? nameUrdu,
    String? nameHindi,
    String? nameArabic,
  }) {
    final defaultName = displayName ?? user.displayName;
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: defaultName,
      nameEnglish: nameEnglish,
      nameUrdu: nameUrdu,
      nameHindi: nameHindi,
      nameArabic: nameArabic,
      profileImagePath: user.photoURL,
      preferredLanguage: language,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'],
      nameEnglish: data['nameEnglish'],
      nameUrdu: data['nameUrdu'],
      nameHindi: data['nameHindi'],
      nameArabic: data['nameArabic'],
      profileImagePath: data['profileImagePath'],
      location: data['location'],
      preferredLanguage: data['preferredLanguage'],
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : null,
    );
  }

  // Convert UserModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'nameEnglish': nameEnglish,
      'nameUrdu': nameUrdu,
      'nameHindi': nameHindi,
      'nameArabic': nameArabic,
      'profileImagePath': profileImagePath,
      'location': location,
      'preferredLanguage': preferredLanguage,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': (updatedAt ?? DateTime.now()).millisecondsSinceEpoch,
    };
  }

  // Copy with method for updates
  UserModel copyWith({
    String? name,
    String? nameEnglish,
    String? nameUrdu,
    String? nameHindi,
    String? nameArabic,
    String? profileImagePath,
    String? location,
    String? preferredLanguage,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameUrdu: nameUrdu ?? this.nameUrdu,
      nameHindi: nameHindi ?? this.nameHindi,
      nameArabic: nameArabic ?? this.nameArabic,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      location: location ?? this.location,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, language: $preferredLanguage)';
  }

  // Get localized name based on language
  String getLocalizedName(String? language) {
    switch (language) {
      case 'en':
        return nameEnglish ?? name ?? 'User';
      case 'ur':
        // If Urdu name exists and is different from default, use it
        if (nameUrdu != null && nameUrdu != name) {
          return nameUrdu!;
        }
        // Otherwise use default name, or translated User if no name at all
        return name ?? 'صارف';
      case 'hi':
        // If Hindi name exists and is different from default, use it
        if (nameHindi != null && nameHindi != name) {
          return nameHindi!;
        }
        // Otherwise use default name, or translated User if no name at all
        return name ?? 'उपयोगकर्ता';
      case 'ar':
        // If Arabic name exists and is different from default, use it
        if (nameArabic != null && nameArabic != name) {
          return nameArabic!;
        }
        // Otherwise use default name, or translated User if no name at all
        return name ?? 'مستخدم';
      default:
        return name ?? nameEnglish ?? 'User';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.nameEnglish == nameEnglish &&
        other.nameUrdu == nameUrdu &&
        other.nameHindi == nameHindi &&
        other.nameArabic == nameArabic &&
        other.profileImagePath == profileImagePath &&
        other.location == location &&
        other.preferredLanguage == preferredLanguage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        nameEnglish.hashCode ^
        nameUrdu.hashCode ^
        nameHindi.hashCode ^
        nameArabic.hashCode ^
        profileImagePath.hashCode ^
        location.hashCode ^
        preferredLanguage.hashCode;
  }
}
