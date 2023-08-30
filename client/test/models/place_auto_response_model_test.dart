import 'package:flutter_test/flutter_test.dart';
import 'package:koja/models/place_auto_response_model.dart';

void main() {
  group('PlaceAutocompleteResponse', () {
    test('fromJson should create an instance with the correct values', () {
      final json = {
        'status': 'OK',
        'predictions': [
          {
            'description': 'Prediction 1',
            'place_id': 'Place ID 1',
            'reference': 'Reference 1',
            'structured_formatting': {
              'main_text': 'Main Text 1',
              'secondary_text': 'Secondary Text 1',
            },
          },
          {
            'description': 'Prediction 2',
            'place_id': 'Place ID 2',
            'reference': 'Reference 2',
            'structured_formatting': {
              'main_text': 'Main Text 2',
              'secondary_text': 'Secondary Text 2',
            },
          },
        ],
      };

      final response = PlaceAutocompleteResponse.fromJson(json);

      expect(response.status, 'OK');

      expect(response.predictions, isNotNull);
      expect(response.predictions!.length, 2);

      final prediction1 = response.predictions![0];
      expect(prediction1.description, 'Prediction 1');
      expect(prediction1.placeId, 'Place ID 1');
      expect(prediction1.reference, 'Reference 1');
      expect(prediction1.structuredFormatting, isNotNull);
      expect(prediction1.structuredFormatting!.mainText, 'Main Text 1');
      expect(prediction1.structuredFormatting!.secondaryText, 'Secondary Text 1');

      final prediction2 = response.predictions![1];
      expect(prediction2.description, 'Prediction 2');
      expect(prediction2.placeId, 'Place ID 2');
      expect(prediction2.reference, 'Reference 2');
      expect(prediction2.structuredFormatting, isNotNull);
      expect(prediction2.structuredFormatting!.mainText, 'Main Text 2');
      expect(prediction2.structuredFormatting!.secondaryText, 'Secondary Text 2');
    });

    test('fromJson should create an instance with null values if JSON fields are missing', () {
      final json = {
        'status': null,
        'predictions': null,
      };

      final response = PlaceAutocompleteResponse.fromJson(json);

      expect(response.status, isNull);
      expect(response.predictions, isNull);
    });

    test('fromJson should create an instance with null predictions if JSON field is null', () {
      final json = {
        'status': 'OK',
        'predictions': null,
      };

      final response = PlaceAutocompleteResponse.fromJson(json);

      expect(response.status, 'OK');
      expect(response.predictions, isNull);
    });

    test('parsePlaceAutocompleteResponse should parse JSON response and return a PlaceAutocompleteResponse instance', () {
      final responseBody = '''
        {
          "status": "OK",
          "predictions": [
            {
              "description": "Prediction",
              "place_id": "Place ID",
              "reference": "Reference",
              "structured_formatting": {
                "main_text": "Main Text",
                "secondary_text": "Secondary Text"
              }
            }
          ]
        }
      ''';

      final response = PlaceAutocompleteResponse.parsePlaceAutocompleteResponse(responseBody);

      expect(response.status, 'OK');

      expect(response.predictions, isNotNull);
      expect(response.predictions!.length, 1);

      final prediction = response.predictions![0];
      expect(prediction.description, 'Prediction');
      expect(prediction.placeId, 'Place ID');
      expect(prediction.reference, 'Reference');
      expect(prediction.structuredFormatting, isNotNull);
      expect(prediction.structuredFormatting!.mainText, 'Main Text');
      expect(prediction.structuredFormatting!.secondaryText, 'Secondary Text');
    });
  });
}
