import 'package:flutter_test/flutter_test.dart';
import 'package:koja/models/structured_format_model.dart';

void main() {
  group('StructuredFormatting', () {
    test('fromJson should create an instance with the correct values', () {
      final json = {
        'main_text': 'Main Text',
        'secondary_text': 'Secondary Text',
      };

      final formatting = StructuredFormatting.fromJson(json);

      expect(formatting.mainText, 'Main Text');
      expect(formatting.secondaryText, 'Secondary Text');
    });

    test('fromJson should create an instance with null values if JSON fields are missing', () {
      final json ={
        'main_text': null,
        'secondary_text': null,
      };
      final formatting = StructuredFormatting.fromJson(json);

      expect(formatting.mainText, isNull);
      expect(formatting.secondaryText, isNull);
    });
  });
}
