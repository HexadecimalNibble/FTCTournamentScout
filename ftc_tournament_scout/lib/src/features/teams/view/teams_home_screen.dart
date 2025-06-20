// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ftc_tournament_scout/src/features/teams/view/event_teams.dart';
import 'package:go_router/go_router.dart';
import 'package:material_color_utilities/utils/math_utils.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';
import './teams_view_model.dart';

class TeamsHomeScreen extends StatelessWidget {
  TeamsHomeScreen({super.key, required this.viewModel});

  final TeamsViewModel viewModel;

  final _formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final oprController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        toolbarHeight: kToolbarHeight * 2,
      ),
      body: ListenableBuilder(
        listenable: viewModel,
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
              rows: viewModel.teams.asMap().entries.map((entry) {
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
                    DataCell(Text(team.opr.toString())),
                    // TODO: MAYBE MOVE THE DELETE BUTTON TO BE INSIDE THE DETAILED TEAM VIEW
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => viewModel.delete.execute(team.number),
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
                // Box takes up 1/2 of window height
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
                            // First tab - Adding custom team
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
                                      decoration: const InputDecoration(labelText: "Team Number"),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || int.tryParse(value) == null) {
                                          return "Enter a valid team number.";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(labelText: "Team Name"),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return "Enter a valid team name.";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: oprController,
                                      decoration: const InputDecoration(labelText: "OPR"),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      validator: (value) {
                                        if (value == null) return null;
                                        if (double.tryParse(value) == null) {
                                          return "Enter a valid OPR or omit this value.";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            viewModel.add.execute(
                                              Team(
                                                number: int.parse(numberController.text),
                                                name: nameController.text.trim(),
                                                opr: oprController.text.isEmpty ? 0.0 : double.parse(oprController.text),
                                              )
                                            );
                                            // Reset form
                                            _formKey.currentState!.reset();

                                            // Close menu
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

                            // Second tab - Adding teams from existing event
                            Center(
                              child: Text("text"),
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