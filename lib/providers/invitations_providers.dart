import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event_model.dart';


final invitationsProvider = StateProvider<List<EventModel>>((ref) => []);

final filteredInvitationsProvider = StateProvider<List<EventModel>>((ref) => []);