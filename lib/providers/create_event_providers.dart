import 'package:flutter_riverpod/flutter_riverpod.dart';

 
final selectedDateProvider = StateProvider<DateTime?>(
  (ref) => null, 
);

final selectedCountryProvider =
    StateProvider<String>((ref) => 'Select Country');

final selectedStateProvider = StateProvider<String>((ref) => 'Select State');

final selectedEventTypeProvider = StateProvider<String>((ref) => '');

final createEventNameProvider = StateProvider<String>((ref) => '');

final createEventDescriptionProvider = StateProvider<String>((ref) => '');

final createEventAddressProvider = StateProvider<String>((ref) => '');

final createEventAddress2Provider = StateProvider<String>((ref) => '');

final createEventZipPostalCodeProvider = StateProvider<String>((ref) => '');