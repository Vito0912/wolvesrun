import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconUtil {

  static Widget getIcon(ActivityType? activityType) {
    if (activityType == ActivityType.WALKING) {
      return const Icon(Icons.directions_walk);
    } else if (activityType == ActivityType.RUNNING) {
      return const Icon(Icons.directions_run);
    } else if (activityType == ActivityType.BIKING) {
      return const Icon(Icons.directions_bike);
    } else {
      return const Icon(Icons.error);
    }
  }

}

class ActivityType {
  final int value;

  const ActivityType._(this.value);

  static const ActivityType WALKING = ActivityType._(1);
  static const ActivityType RUNNING = ActivityType._(2);
  static const ActivityType BIKING = ActivityType._(3);

  static ActivityType? getByValue(int? value) {
    for (var activityType in [WALKING, RUNNING, BIKING]) {
      if (activityType.value == value) {
        return activityType;
      }
    }
    return null;
  }
}