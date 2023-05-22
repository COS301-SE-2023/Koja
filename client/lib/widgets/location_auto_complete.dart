import 'dart:convert';

class PlaceAutocompleteResponse{
  late final String? status;
  late final List<Predictions>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json){
    return PlaceAutocompleteResponse(
      status: json['status'],
      predictions: json['predictions'] != null
        ? (json['predictions']).map<Predictions>((json) => Predictions.fromJson(json))
        .toList()
        : null,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}

class Predictions{

  late final String? description;
  late final String? placeId;
  late final String? reference;
  late final StructuredFormatting? structuredFormatting;

  Predictions({this.description, this.placeId, this.reference, this.structuredFormatting});
  
  factory Predictions.fromJson(Map<String, dynamic> json){
    return Predictions(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null,
    );
  }
  
}

class StructuredFormatting {
  late final String? mainText;
  late final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json){
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}