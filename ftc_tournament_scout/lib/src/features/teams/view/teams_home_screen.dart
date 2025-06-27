// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ftc_tournament_scout/src/features/teams/view/event_teams.dart';
import 'package:ftc_tournament_scout/src/shared/classes/team_stats.dart';
import 'package:go_router/go_router.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';
import './teams_view_model.dart';

Future<Map<String, dynamic>> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://ftc-api.firstinspires.org/v2.0/2024/teams?state=AZ'),
    headers: {"Authorization": 'Basic '},
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load. ${response.statusCode}');
  }
}

class TeamsHomeScreen extends StatefulWidget {
  const TeamsHomeScreen({super.key, required this.viewModel});

  final TeamsViewModel viewModel;

  @override
  State<TeamsHomeScreen> createState() => _TeamsHomeScreenState();
}

class _TeamsHomeScreenState extends State<TeamsHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final customTeamInfo = TextEditingController();

  late Future<Map<String, dynamic>> futureAlbum;

  @override
  void dispose() {
    numberController.dispose();
    nameController.dispose();
    customTeamInfo.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        toolbarHeight: kToolbarHeight * 2,
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('OPR')),
                DataColumn(label: Text('')), // Action column (delete button)
              ],
              rows: widget.viewModel.teams.asMap().entries.map((entry) {
                final index = entry.key;
                final team = entry.value;
                return DataRow.byIndex(
                  index: index,
                  onSelectChanged: (selected) {
                    if (selected == true) {
                      GoRouter.of(context).go('/teams/${team.number}');
                    }
                  },
                  cells: [
                    DataCell(Text(team.number.toString())),
                    DataCell(Text(team.name)),
                    DataCell(Text(team.teamStats.opr)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            widget.viewModel.delete.execute(team.number),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: "Add Custom Team"),
                          Tab(text: "Add Teams from Event"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      autofocus: true,
                                      controller: numberController,
                                      decoration: const InputDecoration(
                                        labelText: "Team Number",
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null ||
                                            int.tryParse(value) == null ||
                                            widget.viewModel.teams.any(
                                              (team) =>
                                                  team.number ==
                                                  int.tryParse(value),
                                            )) {
                                          return "Enter a valid team number that hasn't already been added.";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: "Team Name",
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Enter a valid team name.";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: customTeamInfo,
                                      decoration: const InputDecoration(
                                        labelText: "Custom Team Info",
                                      ),
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            widget.viewModel.add.execute(
                                              Team(
                                                number: int.parse(
                                                  numberController.text,
                                                ),
                                                name: nameController.text
                                                    .trim(),
                                                customTeamInfo:
                                                    customTeamInfo.text.isEmpty
                                                    ? CustomTeamInfo()
                                                    : CustomTeamInfo.fromJson(
                                                        jsonDecode(
                                                          customTeamInfo.text,
                                                        ),
                                                      ),
                                                teamStats: TeamStats(
                                                  opr: "1.0",
                                                  autoOpr: "2.0",
                                                  teleOpOpr: "3.0",
                                                  endGameOpr: "4.0",
                                                ),
                                              ),
                                            );
                                            _formKey.currentState!.reset();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text("Add Team"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Placeholder for second tab
                            Center(
                              child: FutureBuilder<Map<String, dynamic>>(
                                future: futureAlbum,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!.toString());
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }

                                  // By default, show a loading spinner.
                                  return const CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
