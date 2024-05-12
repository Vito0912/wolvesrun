import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wolvesrun/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wolvesrun/globals.dart' as globals;
import 'package:wolvesrun/pages/settings/UserChip.dart';
import 'package:wolvesrun/util/Preferences.dart';

class SettingUi extends StatefulWidget {
  const SettingUi({super.key});

  @override
  State<SettingUi> createState() => _SettingUiState();
}

class _SettingUiState extends State<SettingUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(S.of(context).commonHeading),
            tiles: <SettingsTile>[

              UserChip(title: Text("Texst")),

              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text(S.of(context).language),
                value: Text(Intl.getCurrentLocale()),
                onPressed: (_) {

                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    globals.useDarkTheme = value;
                  });
                  SP().updateBool("useDarkTheme", value);
                },
                initialValue: globals.useDarkTheme,
                leading: Icon(Icons.format_paint),
                title: Text('Use Dark Mode'),
              ),
              SettingsTile(
                title: Text('Change server'),
                description: Text(globals.wolvesRunServer),
                leading: Icon(Icons.cloud),
                onPressed: (_) {
                  showDialog(context: context, builder: (context) {
                    var txt = TextEditingController();
                    txt.text = globals.wolvesRunServer;
                    return AlertDialog(
                      title: Text('Change server'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: txt,
                            decoration: InputDecoration(
                              hintText: S.of(context).serverUrl
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                SP().updateString("server", txt.text);
                                globals.wolvesRunServer = txt.text;
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          )
                        ],
                      ),
                    );
                  });
                }
              )
            ],
          ),
          SettingsSection(
            title: Text(S.of(context).other),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.attribution),
                  title: Text(S.of(context).attribution),
                  onPressed: (_) {
                    showLicensePage(context: context);
                  },
              ),
              SettingsTile(
                  title: Text(S.of(context).systemInformations),
                  value: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(), // the async operation
                    builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                      int _tapCount = 0;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show some sort of loading UI
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Handle the error case
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        // Data is received, so we can show the UI with data
                        return GestureDetector(
                          onTap: () {
                            _tapCount++;
                            if(_tapCount == 10) {
                              _tapCount = 0;
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DriftDbViewer(globals.database)));
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('App Name: ${snapshot.data!.appName}'),
                              Text('Package Name: ${snapshot.data!.packageName}'),
                              Text('Version: ${snapshot.data!.version}'),
                              Text('Build Number: ${snapshot.data!.buildNumber}'),
                            ],
                          ),
                        );
                      } else {
                        // This shouldn't happen as we should be in one of the other states
                        return Text(S.of(context).errorLoadingData);
                      }
                    },
                  ),
              )
            ],
          )
        ],
      ),
    );
  }
}
