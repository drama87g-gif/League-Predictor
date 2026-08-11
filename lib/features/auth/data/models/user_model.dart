import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.country,
    super.favoriteClub,
    super.favoriteNationalTeam,
    super.xp,
    super.coins,
    super.level,
    super.isPremium,
    super.premiumExpiry,
    required super.createdAt,
    required super.lastActive,
    super.achievements,
    super.stats,
    super.fcmTokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      country: json['country'] as String?,
      favoriteClub: json['favoriteClub'] as String?,
      favoriteNationalTeam: json['favoriteNationalTeam'] as String?,
      xp: json['xp'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      isPremium: json['isPremium'] as bool? ?? false,
      premiumExpiry: json['premiumExpiry'] != null 
          ? DateTime.parse(json['premiumExpiry'] as String) 
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      achievements: (json['achievements'] as List<dynamic>?)?.cast<String>() ?? const [],
      stats: (json['stats'] as Map<String, dynamic>?) ?? const {},
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'country': country,
      'favoriteClub': favoriteClub,
      'favoriteNationalTeam': favoriteNationalTeam,
      'xp': xp,
      'coins': coins,
      'level': level,
      'isPremium': isPremium,
      'premiumExpiry': premiumExpiry?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'achievements': achievements,
      'stats': stats,
      'fcmTokens': fcmTokens,
    };
  }

  factory UserModel.fromFirebaseUser(firebaseUser, {Map<String, dynamic>? additionalData}) {
    final now = DateTime.now();
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? additionalData?['displayName'],
      photoUrl: firebaseUser.photoURL ?? additionalData?['photoUrl'],
      country: additionalData?['country'],
      favoriteClub: additionalData?['favoriteClub'],
      favoriteNationalTeam: additionalData?['favoriteNationalTeam'],
      xp: additionalData?['xp'] ?? 0,
      coins: additionalData?['coins'] ?? 0,
      level: additionalData?['level'] ?? 1,
      isPremium: additionalData?['isPremium'] ?? false,
      premiumExpiry: additionalData?['premiumExpiry'] != null 
          ? DateTime.parse(additionalData!['premiumExpiry']) 
          : null,
      createdAt: additionalData?['createdAt'] != null 
          ? DateTime.parse(additionalData!['createdAt']) 
          : now,
      lastActive: now,
      achievements: (additionalData?['achievements'] as List<dynamic>?)?.cast<String>() ?? const [],
      stats: additionalData?['stats'] ?? const {},
      fcmTokens: (additionalData?['fcmTokens'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  UserModel copyWithModel({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? country,
    String? favoriteClub,
    String? favoriteNationalTeam,
    int? xp,
    int? coins,
    int? level,
    bool? isPremium,
    DateTime? premiumExpiry,
    DateTime? createdAt,
    DateTime? lastActive,
    List<String>? achievements,
    Map<String, dynamic>? stats,
    List<String>? fcmTokens,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      country: country ?? this.country,
      favoriteClub: favoriteClub ?? this.favoriteClub,
      favoriteNationalTeam: favoriteNationalTeam ?? this.favoriteNationalTeam,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      achievements: achievements ?? this.achievements,
      stats: stats ?? this.stats,
      fcmTokens: fcmTokens ?? this.fcmTokens,
    );
  }
}
