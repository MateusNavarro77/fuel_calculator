import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_calculator/ui/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('executes action after specified duration', () async {
      final debouncer = Debouncer(duration: const Duration(milliseconds: 100));
      var executed = false;

      debouncer.run(() {
        executed = true;
      });

      expect(executed, isFalse);
      expect(debouncer.isActive, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(executed, isTrue);
      expect(debouncer.isActive, isFalse);
      debouncer.dispose();
    });

    test('resets timer when triggered multiple times in rapid succession', () async {
      final debouncer = Debouncer(duration: const Duration(milliseconds: 100));
      var count = 0;

      debouncer.run(() => count++);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(count, equals(0));

      debouncer.run(() => count++);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(count, equals(0));

      debouncer.run(() => count++);
      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(count, equals(1));
      debouncer.dispose();
    });

    test('cancels pending execution', () async {
      final debouncer = Debouncer(duration: const Duration(milliseconds: 100));
      var executed = false;

      debouncer.run(() {
        executed = true;
      });

      debouncer.cancel();
      expect(debouncer.isActive, isFalse);

      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(executed, isFalse);
      debouncer.dispose();
    });
  });
}
