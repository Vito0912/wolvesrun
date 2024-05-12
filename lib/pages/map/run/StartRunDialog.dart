import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wolvesrun/generated/l10n.dart';
import 'package:wolvesrun/models/arguments/StartRunDialogResult.dart';
import 'package:wolvesrun/widgets/TooltipText.dart';

class StartRunDialog {
  static Future<StartRunDialogResult> show(BuildContext context) async {
    bool _keepItems = false;
    bool _disableEvents = false;
    int _activity = 1;
    int _difficulty = 1;
    int _precision = 2;
    bool start = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Start Run'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TooltipText(
                    text: S.of(context).precision,
                    tooltip: S.of(context).precisionDescription),
                const SizedBox(height: 8),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width - 48,
                  initialLabelIndex: _precision,
                  multiLineText: true,
                  centerText: true,
                  labels: [
                    S.of(context).batterySaving,
                    S.of(context).low,
                    S.of(context).balanced,
                    S.of(context).high,
                  ],
                  onToggle: (index) {
                    if (index != null) {
                      _precision = index;
                    }
                  },
                  cancelToggle: (index) async {
                    if (index != null && index == 0) {
                      return await showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          content: Text(S.of(context).batterySavingInformation),
                          actions: [
                            ElevatedButton(
                              child: Text(S.of(context).cancel,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme
                                        ?.error,
                                  )),
                              onPressed: () {
                                Navigator.pop(dialogContext, true);
                                // Start the run
                              },
                            ),
                            ElevatedButton(
                              child: Text(S.of(context).useItAnyway),
                              onPressed: () {
                                Navigator.pop(dialogContext, false);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return false;
                  },
                ),
                const SizedBox(height: 16),
                TooltipText(
                    text: S.of(context).selectYourActivity,
                    tooltip: S.of(context).activitySelectDescription),
                const SizedBox(height: 8),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width - 48,
                  initialLabelIndex: _activity,
                  labels: [
                    S.of(context).walk,
                    S.of(context).run,
                    S.of(context).bike
                  ],
                  icons: const [
                    Icons.directions_walk,
                    Icons.directions_run,
                    Icons.directions_bike
                  ],
                  onToggle: (index) {
                    if (index != null) _activity = index;
                  },
                ),
                const SizedBox(height: 16),
                TooltipText(
                  text: S.of(context).selectDifficulty,
                  tooltip: S.of(context).selectDifficultyDescription,
                ),
                const SizedBox(height: 8),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width - 48,
                  initialLabelIndex: _difficulty,
                  labels: [
                    S.of(context).easy,
                    S.of(context).medium,
                    S.of(context).hard
                  ],
                  onToggle: (index) {
                    if (index != null) _difficulty = index;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TooltipText(
                      text: S.of(context).keepItems,
                      tooltip: S.of(context).keepItemsDescription,
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return Switch.adaptive(
                          value: _keepItems,
                          onChanged: (value) =>
                              (setState(() => _keepItems = value)));
                    })
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TooltipText(
                      text: S.of(context).disableEvents,
                      tooltip: S.of(context).disableEventsDescription,
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return Switch.adaptive(
                          value: _disableEvents,
                          onChanged: (value) =>
                              (setState(() => _disableEvents = value)));
                    })
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(S.of(context).cancel,
                  style: TextStyle(
                    color: Theme.of(context).buttonTheme.colorScheme?.error,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(S.of(context).start),
              onPressed: () {
                start = true;
                Navigator.of(context).pop();
                // Start the run
              },
            ),
          ],
        );
      },
    );

    return StartRunDialogResult(
      keepItems: _keepItems,
      disableEvents: _disableEvents,
      activity: _activity,
      difficulty: _difficulty,
      precision: _precision,
      start: start,
    );
  }

}
