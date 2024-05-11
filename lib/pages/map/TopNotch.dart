import 'package:flutter/material.dart';

class TopNotch extends StatelessWidget {
  TopNotch({
    super.key,
    required this.distance,
    required this.realDistance,
    required this.duration,
    required this.waypoints,
    required this.position,
  });

  final String distance;
  final String realDistance;
  final String duration;
  final String waypoints;
  final String position;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0)),
        color: Theme.of(context).colorScheme.background.withOpacity(0.9),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distance: ${distance} m',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Real distance: ${realDistance} m',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration: ${duration}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Waypoints: ${waypoints}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Pos: ${position}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
