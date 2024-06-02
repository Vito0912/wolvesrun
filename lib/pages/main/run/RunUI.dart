import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolvesrun/models/Runs.dart';
import 'package:wolvesrun/models/arguments/DetailedRunArguments.dart';
import 'package:wolvesrun/pages/main/run/DetailedRun.dart';
import 'package:wolvesrun/services/database/AppDatabase.dart' as db;
import 'package:wolvesrun/services/network/database/RunDB.dart';
import 'package:wolvesrun/models/Runs.dart' as run_model;
import 'package:wolvesrun/globals.dart' as globals;

// Provider to fetch local runs
final localRunsProvider = FutureProvider<List<run_model.Data>>((ref) async {
  db.AppDatabase dbi = globals.database;

  // Fetch local runs
  List<db.Run> localRuns = await dbi.getAllRuns();
  List<run_model.Data> localDataList = [];

  for (db.Run run in localRuns) {
    run_model.Data data = run_model.Data(
      id: run.id,
      name: run.name,
      type: run.type,
      local: true,
      online: false,
      createdAt: run.createdAt,
      updatedAt: run.updatedAt,
      description: run.description,
      userId: run.userId,
    );
    localDataList.add(data);
  }

  return localDataList;
});

// Provider to fetch remote runs and combine with local runs
final runsProvider = FutureProvider<Runs>((ref) async {
  // Fetch local runs
  List<run_model.Data> localDataList = await ref.watch(localRunsProvider.future);
  Runs runs = run_model.Runs(data: List.from(localDataList));

  // Fetch remote runs
  var response = await RunDB.get(context: null, hideError: true);
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    Runs remoteRuns = run_model.Runs.fromJson(json);

    for (run_model.Data remoteRun in remoteRuns.data) {
      bool found = false;
      for (run_model.Data localRun in runs.data) {
        if (remoteRun.id == localRun.id) {
          localRun.online = true;
          localRun.local = true;
          found = true;
          break;
        }
      }
      if (!found) {
        remoteRun.online = true;
        runs.data.add(remoteRun);
      }
    }
  }

  // Sort runs by updatedAt (if null, then by createdAt)
  runs.data.sort((a, b) {
    DateTime aTime = a.updatedAt ?? a.createdAt;
    DateTime bTime = b.updatedAt ?? b.createdAt;
    return bTime.compareTo(aTime); // For descending order
  });

  return runs;
});



class RunUi extends ConsumerWidget {
  const RunUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runsAsyncValue = ref.watch(runsProvider);

    return Scaffold(
      body: runsAsyncValue.when(
        data: (runs) => RefreshIndicator(
          onRefresh: () => ref.refresh(runsProvider.future),
          child: ListView.builder(
            itemCount: runs.data.length,
            itemBuilder: (BuildContext context, int index) {
              run_model.Data run = runs.data[index];
              print(run.name);
              print(run.local);
              print(run.online);
              print("-----");
              return ListTile(
                title: Text(run.name),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${run.type ?? ''} - ${run.totalDistance ?? ''}'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _uploadButton(run),
                        run.local ? const Icon(Icons.offline_pin_outlined) : const SizedBox(),
                        run.online ? const Icon(Icons.cloud_outlined) : const SizedBox(),
                        _statusWidget(run.syncStatus),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DetailedRun.routeName,
                    arguments: DetailedRunArguments(run.id, run.name),
                  );
                },
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          debugPrint('Error: $err $stack');
          return Center(child: Text('Error: $err'));
        },
      ),
    );
  }

  Widget _uploadButton(run_model.Data run) {
    Widget button = const SizedBox();

    if(globals.hasConnection && globals.user != null) {
      if(run.local && !run.online) {
        IconButton(onPressed: () => (), icon:
      const Icon(Icons.upload_outlined),
      );
      }
    }

    return button;
  }

  Widget _statusWidget(db.SyncStatus? status) {
    switch (status) {
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
