import 'package:flutter_riverpod/flutter_riverpod.dart';

final reminderDaysProvider = StateProvider<List<int>>((_) => [3, 1]);
