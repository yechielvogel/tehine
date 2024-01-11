import 'package:flutter_riverpod/flutter_riverpod.dart';

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
