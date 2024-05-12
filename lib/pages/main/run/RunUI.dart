import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wolvesrun/models/Runs.dart';
import 'package:wolvesrun/models/arguments/DetailedRunArguments.dart';
import 'package:wolvesrun/pages/main/run/DetailedRun.dart';
import 'package:wolvesrun/services/database/AppDatabase.dart' as db;
import 'package:wolvesrun/services/network/database/RunDB.dart';
import 'package:wolvesrun/models/Runs.dart' as run_model;
import 'package:wolvesrun/globals.dart' as globals;

class RunUi extends StatefulWidget {
  const RunUi({super.key});

  @override
  State<RunUi> createState() => _RunUiState();
}

class _RunUiState extends State<RunUi> {
  bool _isLoading = true;
  Runs? runs;
  db.SyncStatus? syncStatus;

  @override
  void initState() {
    db.AppDatabase dbi = globals.database;

    dbi.getAllRuns().then((value) async {
      runs ??= run_model.Runs(data: []);
      for(db.Run run in value) {
        run_model.Data data = run_model.Data(
          id: run.id,
          name: run.name,
          type: run.type,
          local: true,
          online: false,
          createdAt: run.createdAt,
          updatedAt: run.updatedAt,
          description: run.description,
          avSpeed: '0',
          distance: '0',
          userId: run.userId,
        );


      bool found = false;
        for(run_model.Data element2 in runs!.data) {
            if(data.id == element2.id) {
              element2.local = true;
              syncStatus = await globals.database.getSyncStatusByRunId(data.id);
              element2.syncStatus = syncStatus;
              found = true;
              break;
            }
        }

        if(!found) runs!.data.add(data);
      }
      setState(() {
        _isLoading = false;
      });
    });

    RunDB.get(context: context).then((value) {
      if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);
        Runs? run_tmp = runs;
        runs = run_model.Runs.fromJson(json);
        if(run_tmp != null) {
          for (run_model.Data element in run_tmp.data) {
            bool found = false;
            for(run_model.Data element2 in runs!.data) {
              if(element.id == element2.id) {
                element2.local = true;
                found = true;
                break;
              }
            }
            if(!found) runs!.data.add(element);
          }
        }
        setState(() {
          _isLoading = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading && runs != null ? _runList() : _loadingList(),
    );
  }

  Widget _loadingList() {
    return const CircularProgressIndicator();
  }

  Widget _runList() {
    return ListView.builder(
        itemCount: runs!.data.length,
        itemBuilder: (BuildContext context, int index) {
          run_model.Data run = runs!.data[index];

          return ListTile(
              title: Text(run.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${run.type}'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TODO: Add partial icon when it's online and local (check then if completely online!)
                      run.local
                          ? const Icon(
                              Icons.offline_pin_outlined,
                            )
                          : const SizedBox(),
                      run.online
                          ? const Icon(Icons.cloud_outlined)
                          : const SizedBox(),
                      _stausWidget(run.syncStatus),
                    ],
                  )
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DetailedRun.routeName,
                  arguments: DetailedRunArguments(run.id, run.name),
                );
              });
        });



  }

  Widget _stausWidget(db.SyncStatus? status) {
    switch(status) {
      case db.SyncStatus.synced:
        return const Icon(Icons.check_circle_outline);
      case db.SyncStatus.partial:
        return const Icon(Icons.warning_amber);
      case db.SyncStatus.notSynced:
        return const Icon(Icons.error_outline);
      default:
        return const SizedBox();
    }
  }
}
