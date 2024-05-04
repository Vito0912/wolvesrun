import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wolvesrun/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingUi extends StatelessWidget {
  const SettingUi({super.key});

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
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text(S.of(context).language),
                value: Text("English"),
                onPressed: (_) {

                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show some sort of loading UI
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Handle the error case
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        // Data is received, so we can show the UI with data
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('App Name: ${snapshot.data!.appName}'),
                            Text('Package Name: ${snapshot.data!.packageName}'),
                            Text('Version: ${snapshot.data!.version}'),
                            Text('Build Number: ${snapshot.data!.buildNumber}'),
                          ],
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
