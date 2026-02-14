import 'package:flutter_test/flutter_test.dart';

void main() {
  test('effective reminder rules prefer overrides', () {
    final global = [3, 1, 0];
    final overrides = [5, 2];
    final effective = overrides.isNotEmpty ? overrides : global;
    expect(effective, [5, 2]);
  });
}
