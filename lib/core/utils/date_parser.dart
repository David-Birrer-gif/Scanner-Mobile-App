import 'package:intl/intl.dart';

DateTime? parseDateFromText(String text) {
  final candidates = [
    RegExp(r'(\d{2}[./-]\d{2}[./-]\d{2,4})'),
    RegExp(r'(\d{4}[./-]\d{2}[./-]\d{2})'),
  ];

  for (final regex in candidates) {
    final match = regex.firstMatch(text);
    if (match == null) continue;
    final value = match.group(1)!;
    for (final pattern in ['dd.MM.yyyy', 'dd/MM/yyyy', 'dd-MM-yyyy', 'yyyy-MM-dd']) {
      try {
        return DateFormat(pattern).parseStrict(value);
      } catch (_) {
        // Continue trying fallback formats.
      }
    }
  }
  return null;
}
