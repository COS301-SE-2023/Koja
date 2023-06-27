import './structured_format_model.dart';

class AutocompletePrediction {
  late final String? description;
  late final StructuredFormatting? structuredFormatting;
  late final String? placeId;
  late final String? reference;

  AutocompletePrediction(
      {this.description,
      this.placeId,
      this.reference,
      this.structuredFormatting});

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}
