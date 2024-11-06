import 'package:flutter/material.dart';

// common
final Gradient backgroundColor = LinearGradient(
  colors: [
    const Color(0xFF36D1DC).withOpacity(0.1),
    const Color(0xFF5B86E5).withOpacity(0.1),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const Color titleColor = Color(0xFF0C7BB3);
const Color buttonColor = Color(0xFF0C7BB3);
const Color buttonTextColor = Colors.white;
const Color successMessageBackground = Color(0xff399918);

// list screen
const Color searchBackgroundColor = Colors.transparent;
const Color searchTextColor = Color(0xFF0C7BB3);
const TextStyle searchInputStyle =
    TextStyle(color: Color(0xFF0C7BB3), fontWeight: FontWeight.w500);
const Color quickActionColor = Color(0xFF0C7BB3);
const Color noteMapKeyTextColor = Colors.black87;
final Color noteCardBackgroundColor = Color(0xFF0C7BB3).withOpacity(0.70);
const Color notePinnedCardBackgroundColor = Color(0xFF0C7BB3);
const Color noteTitleTextColor = Colors.white;
final Color noteSubtitleTextColor = Colors.white.withOpacity(0.64);
const Color notePinnedActiveColor = Colors.orange;
const Color notePinnedInactiveColor = Colors.black54;

// add screen
const TextStyle inputLabelStyle =
    TextStyle(color: Color(0xFF0C7BB3), fontWeight: FontWeight.w700);
const TextStyle inputStyle =
    TextStyle(color: Color(0xFF0C7BB3), fontWeight: FontWeight.w700);

// edit screen
const Color pinQuickActionColor = Colors.orange;
const Color deleteQuickActionColor = Colors.pink;
