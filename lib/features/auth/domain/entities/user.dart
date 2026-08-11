import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? country;
  final String? favoriteClub;
  final String? favoriteNationalTeam;
  final int xp;
  final int coins;
  final int level;
  final bool isPremium;
  final DateTime? premiumExpiry;
  final DateTime createdAt;
  final DateTime lastActive;
  final List<String> achievements;
  final Map<String, dynamic> stats;
  final List<String> fcmTokens;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.country,
    this.favoriteClub,
    this.favoriteNationalTeam,
    this.xp = 0,
    this.coins = 0,
    this.level = 1,
    this.isPremium = false,
    this.premiumExpiry,
    required this.createdAt,
    required this.lastActive,
    this.achievements = const [],
    this.stats = const {},
    this.fcmTokens = const [],
  });

  User copyWith({
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
    return User(
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

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, country, favoriteClub, 
      favoriteNationalTeam, xp, coins, level, isPremium, premiumExpiry, createdAt, 
      lastActive, achievements, stats, fcmTokens];
}
