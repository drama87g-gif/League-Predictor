import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('MMM dd, yyyy').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);
  String get formattedDateTime => DateFormat('MMM dd, HH:mm').format(this);
  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  String get matchStatus {
    final now = DateTime.now();
    if (isBefore(now)) return 'LIVE';
    if (isToday) return 'TODAY';
    if (isTomorrow) return 'TOMORROW';
    return formattedDate;
  }
}

extension StringExtension on String {
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get titleCase => split(' ').map((s) => s.capitalize).join(' ');

  String get initials {
    final parts = trim().split(' ');
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}

extension NumberExtension on num {
  String get compact => NumberFormat.compact().format(this);
  String get percentage => NumberFormat.percentPattern().format(this / 100);
  String get currency => NumberFormat.currency(symbol: '\$').format(this);
}

extension WidgetExtension on Widget {
  Widget withPadding(EdgeInsets padding) => Padding(padding: padding, child: this);
  Widget centered() => Center(child: this);
  Widget expanded() => Expanded(child: this);
  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);
}
