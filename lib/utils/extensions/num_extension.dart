import 'dart:math' as math;

extension NumExtension on num {
  String toByteString() {
    return '${this / math.pow(2, 10)} kB';
  }
}
