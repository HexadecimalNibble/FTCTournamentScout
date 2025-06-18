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
    // PlaylistsProvider playlistProvider = PlaylistsProvider();
    // List<Playlist> playlists = playlistProvider.playlists;
    // List<Team> teams = <Team>[Team(number: 1, name: "testname", opr: 123.0), Team(number: 13242, name: "team2", opr: 163.2)];
    final Event testEvent = Event(date: "5/5/25", name: "test event", teams: <Team>[Team(number: 1, name: "testname", opr: 123.0), Team(number: 13242, name: "team2", opr: 163.2)], matches: <Match>[Match(red1: Team(number: 1, name: "testname", opr: 123.0), red2: Team(number: 1, name: "testname", opr: 123.0), blue1: Team(number: 1, name: "testname", opr: 123.0), blue2: Team(number: 1, name: "testname", opr: 123.0))]);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          primary: false,
          appBar: AppBar(
            title: const Text('TEAMS'),
            toolbarHeight: kToolbarHeight * 2,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdaptiveTable<Team>(
                items: testEvent.teams,
                breakpoint: 450,
                columns: const [
                  DataColumn(
                    label: Padding(padding: EdgeInsets.only(left: 20), child: Text('#')),
                  ),
                  DataColumn(label: Text('Name')),
                  DataColumn(
                    label: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text('OPR'),
                    ),
                  ),
                ],
                rowBuilder: (context, index) => DataRow.byIndex(
                  index: index,
                  onSelectChanged: (selected) {
                    if (selected != null && selected) {
                      final team = testEvent.teams[index];
                      GoRouter.of(context).go('/playlists/${team.number}');
                    }
                  },

                  cells: [
                    DataCell(Text(testEvent.teams[index].number.toString())),
                    DataCell(Text(testEvent.teams[index].name)),
                    DataCell(Text(testEvent.teams[index].opr.toString()))
                    // DataCell(
                    //   HoverableSongPlayButton(
                    //     hoverMode: HoverMode.overlay,
                    //     song: event.teams[index],
                    //     child: Center(
                    //       child: Text(
                    //         (index + 1).toString(),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // DataCell(
                    //   Row(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(2),
                    //         child: ClippedImage(event.teams[index].image.image),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       Expanded(child: Text(event.songs[index].title)),
                    //     ],
                    //   ),
                    // ),
                    // DataCell(Text(event.teams[index].name)),
                  ],
                ),
                itemBuilder: (song, index) {
                  return ListTile(
                    // onTap: () => BlocProvider.of<PlaybackBloc>(
                    //   context,
                    // ).add(PlaybackEvent.changeSong(song)),
                    // leading: ClippedImage(song.image.image),
                    // title: Text(song.title),
                    // subtitle: Text(song.length.toHumanizedString()),
                  );
                },
              )
              // Expanded(
              //   child: GridView.builder(
              //     padding: const EdgeInsets.all(15),
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: (constraints.maxWidth ~/ 175).toInt(),
              //       childAspectRatio: 0.70,
              //       mainAxisSpacing: 10,
              //       crossAxisSpacing: 10,
              //     ),
              //     itemCount: teams.length,
              //     itemBuilder: (context, index) {
              //       final team = teams[index];
              //       return GestureDetector(
              //         // child: ImageTile(
              //         //   image: playlist.cover.image,
              //         //   title: playlist.title,
              //         //   subtitle: playlist.description,
              //         // ),
              //         child: Text(
              //           team.name
              //         ),
              //         onTap: () =>
              //             GoRouter.of(context).go('/playlists/${team}'),
              //       );
              //     },
              //   ),
              // ),


              // LayoutBuilder(
              //   builder: (context, constraints) =>
              //       EventTeams(
              //         event: Event(date: "5/5/25", name: "test event", teams: <Team>[Team(number: 1, name: "testname", opr: 123.0), Team(number: 13242, name: "team2", opr: 163.2)], matches: <Match>[Match(red1: Team(number: 1, name: "testname", opr: 123.0), red2: Team(number: 1, name: "testname", opr: 123.0), blue1: Team(number: 1, name: "testname", opr: 123.0), blue2: Team(number: 1, name: "testname", opr: 123.0))])
              //       ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
