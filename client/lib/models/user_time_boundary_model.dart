import 'package:intl/intl.dart';

enum TimeBoundaryType {
  allowed,
  blocked,
}

class UserTimeBoundaryModel {
  String? name;
  String? startTime;
  String? endTime;
  TimeBoundaryType? type;
  int? id;

  UserTimeBoundaryModel({
    this.name,
    this.startTime,
    this.endTime,
    this.type = TimeBoundaryType.allowed,
    this.id,
  });

  String? getName() => name;

  String? getStartTime() => startTime;

  String? getEndTime() => endTime;

  void setName(String? value) {
    name = value;
  }

  void setStartTime(String? value) {
    startTime = value;
  }

  void setEndTime(String? value) {
    endTime = value;
  }

  TimeBoundaryType? getType() => type;

  void setType(TimeBoundaryType? value) {
    if (value != null) {
      type = value;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name != null ? name!.trim() : '',
      'startTime': startTime != null ? startTime!.trim() : '',
      'endTime': endTime != null ? endTime!.trim() : '',
      'type': type == TimeBoundaryType.allowed ? 'allowed' : 'blocked',
      'id': id,
    };
  }

  factory UserTimeBoundaryModel.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final exportFormat = DateFormat('HH:mm');

    DateTime parseTime(String? timeStr) {
      if (timeStr != null && timeStr.isNotEmpty) {
        // Use a dummy date
        return dateFormat.parseUtc('2000-01-01 $timeStr').toLocal();
      } else {
        return DateTime.now();
      }
    }

    return UserTimeBoundaryModel(
      name: json['name'],
      startTime: exportFormat.format(parseTime(json['startTime'])),
      endTime: exportFormat.format(parseTime(json['endTime'])),
      type: json['type'] == 'allowed'
          ? TimeBoundaryType.allowed
          : TimeBoundaryType.blocked,
      id: json['id'],
    );
  }
}
