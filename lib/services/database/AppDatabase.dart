import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:wolvesrun/globals.dart' as globals;
import 'package:wolvesrun/services/database/Positions.dart';
import 'package:wolvesrun/services/database/Runs.dart';

part 'AppDatabase.g.dart';

@DriftDatabase(tables: [Runs, Positions])

class AppDatabase extends _$AppDatabase {

  static AppDatabase instance() => AppDatabase();

  AppDatabase() : super(_openConnection());

  int get schemaVersion => 5;

  Future<List<Run>> getAllRuns() => select(runs).get();

  Future<List<Position>> getAllPositionsByRunId(int runId) {
    return (select(positions)..where((tbl) => tbl.runId.equals(runId))).get();
  }

  Future<SyncStatus> getSyncStatusByRunId(int runId) async {
    // Retrieve all positions associated with the given runId
    final List<Position> positions = await (select(this.positions)..where((p) => p.runId.equals(runId))).get();

    if (positions.isEmpty) {
      // If no positions are found, we may consider it as not synced or handle it separately
      return SyncStatus.notSynced;
    }

    // Count the number of positions that have been uploaded
    int uploadedCount = positions.where((position) => position.uploaded).length;

    if (uploadedCount == 0) {
      // None of the positions are uploaded
      return SyncStatus.notSynced;
    } else if (uploadedCount == positions.length) {
      // All positions are uploaded
      return SyncStatus.synced;
    } else {
      // Some, but not all, positions are uploaded
      return SyncStatus.partial;
    }
  }


  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < to) {
          await m.deleteTable('runs');
          await m.deleteTable('positions');
          await m.createAll();
        }
      },
      beforeOpen: (details) async {

      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() {
    final file = File(p.join(globals.directoryPath!, 'app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

enum SyncStatus {
  notSynced,
  synced,
  partial
}