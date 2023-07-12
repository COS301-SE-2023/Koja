import 'package:flutter_test/flutter_test.dart';
import 'package:client/models/autocomplete_predict_model.dart';
import 'package:client/models/structured_format_model.dart';

void main() {
  group('AutocompletePrediction', () {
    test('fromJson should create an instance with the correct values', () {
      final json = {
        'description': 'Prediction Description',
        'place_id': 'Place ID',
        'reference': 'Reference',
        'structured_formatting': {
          'main_text': 'Main Text',
          'secondary_text': 'Secondary Text',
        },
      };

      final prediction = AutocompletePrediction.fromJson(json);

      expect(prediction.description, 'Prediction Description');
      expect(prediction.placeId, 'Place ID');
      expect(prediction.reference, 'Reference');

      expect(prediction.structuredFormatting, isNotNull);
      expect(prediction.structuredFormatting!.mainText, 'Main Text');
      expect(prediction.structuredFormatting!.secondaryText, 'Secondary Text');
    });

    test('fromJson should create an instance with null values if JSON fields are missing', () {
      final json = {
        'description': null,
        'place_id': null,
        'reference': null,
        'structured_formatting': null,
      };

      final prediction = AutocompletePrediction.fromJson(json);

      expect(prediction.description, isNull);
      expect(prediction.placeId, isNull);
      expect(prediction.reference, isNull);
      expect(prediction.structuredFormatting, isNull);
    });

    test('fromJson should create an instance with null structuredFormatting if JSON field is null', () {
      final json = {
        'description': 'Prediction Description',
        'place_id': 'Place ID',
        'reference': 'Reference',
        'structured_formatting': null,
      };

      final prediction = AutocompletePrediction.fromJson(json);

      expect(prediction.description, 'Prediction Description');
      expect(prediction.placeId, 'Place ID');
      expect(prediction.reference, 'Reference');
      expect(prediction.structuredFormatting, isNull);
    });
  });
}
