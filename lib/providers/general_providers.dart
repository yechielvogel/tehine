import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = StateProvider<bool>(
  (ref) => false,
);

final selectedListScreenChipIndexProvider = StateProvider<int>((ref) => 0);


final searchQueryProvider = StateProvider<String>((ref) => '');

// Date providers

final selectedDateProvider = StateProvider<DateTime?>(
  (ref) => null,
);

final todayEnglishDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final selectedEnglishDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final todayHebrewDateProvider = StateProvider<String>(
  (ref) => '',
);

final selectedHebrewDateProvider = StateProvider<String>(
  (ref) => '',
);

final selectedHebrewMonthDateProvider = StateProvider<String>(
  (ref) => '',
);

final offsetProvider = StateProvider<String>(
  (ref) => '',
);


final selectedChipIndexForInvitationTileProvider = StateProvider.family<int?, String>((ref, tileId) => null);

final selectedInvitationScreenChipIndexProvider =
    StateProvider<int>((ref) => 1);