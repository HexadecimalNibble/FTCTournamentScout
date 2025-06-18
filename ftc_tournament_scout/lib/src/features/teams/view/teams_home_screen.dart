// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:ftc_tournament_scout/src/features/teams/view/event_teams.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';

class PlaylistHomeScreen extends StatelessWidget {
  const PlaylistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Event testEvent = Event(
      date: "5/5/25",
      name: "test event",
      teams: [
        Team(number: 1, name: "testname", opr: 123.0),
        Team(number: 13242, name: "team2", opr: 163.2),
      ],
      matches: [
        Match(
          red1: Team(number: 1, name: "testname", opr: 123.0),
          red2: Team(number: 1, name: "testname", opr: 123.0),
          blue1: Team(number: 1, name: "testname", opr: 123.0),
          blue2: Team(number: 1, name: "testname", opr: 123.0),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        toolbarHeight: kToolbarHeight * 2,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          showCheckboxColumn: false, // used to hide checkboxes from onSelectChanged
          columns: const [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('OPR')),
          ],
          rows: testEvent.teams.asMap().entries.map((entry) {
            final index = entry.key;
            final team  = entry.value;
            return DataRow.byIndex(
              index: index,
              onSelectChanged: (selected) {
                if (selected == true) {
                  GoRouter.of(context).go('/playlists/${team.number}');
                }
              },
              cells: [
                DataCell(Text(team.number.toString())),
                DataCell(Text(team.name)),
                DataCell(Text(team.opr.toString())),
              ],
            );
          }).toList(),
        )

      ),
    );
  }
}
