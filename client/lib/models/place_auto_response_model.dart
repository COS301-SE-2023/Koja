import 'dart:convert';

import './autocomplete_predict_model.dart';

class placeAutocompleteResponse 
{
  late final String? status;
  late final List<AutocompletePrediction>? predictions;

  placeAutocompleteResponse({this.status, this.predictions});

  factory placeAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return placeAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? (json['predictions'])
              .map<AutocompletePrediction>(
                (json) => AutocompletePrediction.fromJson(json))
              .toList()
          : null,
    );
  }

  static placeAutocompleteResponse parsePlaceAutocompleteResponse(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<String, dynamic>();
    return placeAutocompleteResponse.fromJson(parsed);
  }
}