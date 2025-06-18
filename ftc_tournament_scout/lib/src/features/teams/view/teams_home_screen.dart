// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
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
    List<Team> teams = <Team>[Team(number: 1, name: "testname", opr: 123.0), Team(number: 13242, name: "team2", opr: 163.2)];
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          primary: false,
          appBar: AppBar(
            title: const Text('TEAMS'),
            toolbarHeight: kToolbarHeight * 2,
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (constraints.maxWidth ~/ 175).toInt(),
                    childAspectRatio: 0.70,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return GestureDetector(
                      // child: ImageTile(
                      //   image: playlist.cover.image,
                      //   title: playlist.title,
                      //   subtitle: playlist.description,
                      // ),
                      child: Text(
                        team.name
                      ),
                      onTap: () =>
                          GoRouter.of(context).go('/playlists/${team}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
