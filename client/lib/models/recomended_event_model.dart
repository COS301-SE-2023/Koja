class RecomendedEventModel {
  final String eventName;
  final List<String> timeframes;
  final List<String> weekdays;
  bool isExpanded = false;

  RecomendedEventModel({
    required this.eventName,
    required this.timeframes,
    required this.weekdays,
  });
}
