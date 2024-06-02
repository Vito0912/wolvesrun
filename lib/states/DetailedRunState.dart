import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wolvesrun/models/arguments/DetailedRunArguments.dart';
import 'package:wolvesrun/services/database/AppDatabase.dart' as db;
import 'package:wolvesrun/services/network/database/RunDB.dart';
import 'package:wolvesrun/models/DetailedRun.dart' as model;
import 'package:wolvesrun/globals.dart' as globals;
import 'package:latlong2/latlong.dart';

class DetailedRunNotifier
    extends StateNotifier<AsyncValue<model.RunDetailed?>> {
  DetailedRunNotifier() : super(const AsyncValue.loading());

  Future<void> loadDetailedRun(
      DetailedRunArguments args, BuildContext context) async {
    try {
      state = const AsyncValue.loading();

      final syncStatus =
          await globals.database.getSyncStatusByRunId(args.runId);
      bool isOnline = false;

      if ((syncStatus == db.SyncStatus.synced ||
              syncStatus == db.SyncStatus.notLocal) &&
          globals.hasConnection &&
          globals.user != null) {
        late final http.Response response;

        if (context.mounted) {
          response = await RunDB.getById(id: args.runId, context: context);
        } else {
          response = await RunDB.getById(id: args.runId, context: null);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          model.RunDetailed run =
              model.RunDetailed.fromJson(jsonDecode(response.body));
          run.data!.syncStatus = syncStatus;

          state = AsyncValue.data(run);
          isOnline = true;
        }
      }

      if (!isOnline) {
        await _fetchLocal(args, syncStatus);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _fetchLocal(
      DetailedRunArguments args, db.SyncStatus status) async {
    final positionsData =
        await globals.database.getAllPositionsByRunId(args.runId);
    final positions = positionsData.map((position) {
      return model.Positions(
        timestamp: position.timestamp,
        speed: position.speed,
        location: model.Location(
          type: 'Point',
          latLng: LatLng(position.latitude, position.longitude),
          altitude: position.altitude,
        ),
      );
    }).toList();

    model.Data tmp = model.Data(
        name: 'Local Run - Not implemented yet',
        description: 'Local Run - Not implemented yet',
        positions: positions,
        syncStatus: status);

    tmp.calculateLocal();

    state = AsyncValue.data(model.RunDetailed(
      data: tmp,
    ));
  }
}

final detailedRunProvider =
    StateNotifierProvider<DetailedRunNotifier, AsyncValue<model.RunDetailed?>>(
        (ref) {
  return DetailedRunNotifier();
});
