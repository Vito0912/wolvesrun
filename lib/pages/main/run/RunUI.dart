import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wolvesrun/models/Runs.dart';
import 'package:wolvesrun/models/arguments/DetailedRunArguments.dart';
import 'package:wolvesrun/pages/main/run/DetailedRun.dart';
import 'package:wolvesrun/services/network/database/RunDB.dart';
import 'package:wolvesrun/models/Runs.dart' as run_model;

class RunUi extends StatefulWidget {
  const RunUi({super.key});

  @override
  State<RunUi> createState() => _RunUiState();
}

class _RunUiState extends State<RunUi> {
  bool _isLoading = true;
  Runs? runs;

  @override
  void initState() {
    RunDB.get(context: context).then((value) {
      if (value.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(value.body);
        print(json);
        runs = Runs.fromJson(json);
        print(runs);
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
                      run.local
                          ? const Icon(
                              Icons.offline_pin_outlined,
                            )
                          : const SizedBox(),
                      run.online
                          ? const Icon(Icons.cloud_outlined)
                          : const SizedBox(),
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
}
