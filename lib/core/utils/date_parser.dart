import 'package:intl/intl.dart';

class ParsedDateCandidate {
  const ParsedDateCandidate(this.original, this.date);
  final String original;
  final DateTime date;
}

class DateParser {
  static final List<RegExp> _patterns = [
    RegExp(r'(\d{2}[./-]\d{2}[./-]\d{4})'),
    RegExp(r'(\d{2}[./-]\d{2}[./-]\d{2})'),
    RegExp(r'(\d{4}[./-]\d{2}[./-]\d{2})'),
  ];

  static final List<String> _formats = [
    'dd.MM.yyyy',
    'dd/MM/yyyy',
    'dd-MM-yyyy',
    'yyyy-MM-dd',
    'yyyy/MM/dd',
    'dd.MM.yy',
    'dd/MM/yy',
    'dd-MM-yy',
  ];

  static List<ParsedDateCandidate> extractDates(String text) {
    final normalized = text
        .replaceAll('MHD', ' ')
        .replaceAll('Mindestens haltbar bis', ' ')
        .replaceAll('Zu verbrauchen bis', ' ')
        .replaceAll('EXP', ' ')
        .replaceAll('Best before', ' ');

    final candidates = <ParsedDateCandidate>[];
    for (final regex in _patterns) {
      for (final match in regex.allMatches(normalized)) {
        final value = match.group(1);
        if (value == null) continue;
        final parsed = _parseSingle(value);
        if (parsed != null) {
          candidates.add(ParsedDateCandidate(value, parsed));
        }
      }
    }

    final unique = <int, ParsedDateCandidate>{};
    for (final c in candidates) {
      unique[c.date.millisecondsSinceEpoch] = c;
    }
    final values = unique.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    return values;
  }

  static DateTime? parseFirst(String text) {
    final dates = extractDates(text);
    return dates.isEmpty ? null : dates.first.date;
  }

  static DateTime? _parseSingle(String value) {
    for (final format in _formats) {
      try {
        final parsed = DateFormat(format).parseStrict(value);
        if (parsed.year < 100) {
          return DateTime(2000 + parsed.year, parsed.month, parsed.day);
        }
        return DateTime(parsed.year, parsed.month, parsed.day);
      } catch (_) {
        continue;
      }
    }
    return null;
  }
}
