import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wolvesrun/globals.dart' as globals;

class UserChip extends SettingsTile {
  UserChip({super.key, required super.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: globals.user != null ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          globals.user!.username,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text("${globals.user!.firstName} ${globals.user!.lastName}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          globals.user!.email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                ],
              ) :
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, "/signIn",
                  ).then((value) => setState((){}));
                },
                splashColor: Theme.of(context).colorScheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "You are currently not logged in",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "Please log in to access all features",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
