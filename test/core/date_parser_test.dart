import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_mobile_app/core/utils/date_parser.dart';

void main() {
  test('parses multiple date formats', () {
    expect(DateParser.parseFirst('EXP 2026-12-04'), DateTime(2026, 12, 4));
    expect(DateParser.parseFirst('MHD 04.12.2026'), DateTime(2026, 12, 4));
    expect(DateParser.parseFirst('Best before 04/12/26'), DateTime(2026, 12, 4));
  });
}
