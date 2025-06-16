// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
import '../../../shared/providers/providers.dart';
import '../../../shared/views/views.dart';
import '../../../utils/adaptive_components.dart';
import '../../playlists/view/event_teams.dart';
import 'view.dart';
import 'package:http/http.dart' as http; // DO THIS https://docs.flutter.dev/cookbook/networking/fetch-data

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final PlaylistsProvider playlistProvider = PlaylistsProvider();
    // final List<Playlist> playlists = playlistProvider.playlists;
    // final Playlist topSongs = playlistProvider.topSongs;
    // final Playlist newReleases = playlistProvider.newReleases;
    // final ArtistsProvider artistsProvider = ArtistsProvider();
    // final List<Artist> artists = artistsProvider.artists;
    final Event testEvent = Event(date: "5/5/25", name: "test event", teams: <Team>[Team(number: 1, name: "testname", opr: 123.0)], matches: <Match>[Match(red1: Team(number: 1, name: "testname", opr: 123.0), red2: Team(number: 1, name: "testname", opr: 123.0), blue1: Team(number: 1, name: "testname", opr: 123.0), blue2: Team(number: 1, name: "testname", opr: 123.0))]);

    return LayoutBuilder(
      builder: (context, constraints) {
        // if (constraints.isMobile) {
        //   return DefaultTabController(
        //     length: 4,
        //     child: Scaffold(
        //       appBar: AppBar(
        //         centerTitle: false,
        //         title: const Text('FTC Tournament Scout'),
        //         actions: const [BrightnessToggle()],
        //         bottom: const TabBar(
        //           isScrollable: true,
        //           tabs: [
        //             Tab(text: 'Home'),
        //             Tab(text: 'Recently Played'),
        //             Tab(text: 'New Releases'),
        //             Tab(text: 'Top Songs'),
        //           ],
        //         ),
        //       ),
        //       body: LayoutBuilder(
        //         builder: (context, constraints) => TabBarView(
        //           children: [
        //             SingleChildScrollView(
        //               child: Column(
        //                 children: [
        //                   const HomeHighlight(),
        //                   HomeArtists(
        //                     artists: artists,
        //                     constraints: constraints,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             HomeRecent(playlists: playlists, axis: Axis.vertical),
        //             PlaylistSongs(playlist: topSongs, constraints: constraints),
        //             PlaylistSongs(
        //               playlist: newReleases,
        //               constraints: constraints,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   );
        // }
        return Scaffold(
          body: SingleChildScrollView(
            child: AdaptiveColumn(
              children: [
                AdaptiveContainer(
                  columnSpan: 12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'FTC Tournament Scout',
                            style: context.displaySmall,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const BrightnessToggle(),
                      ],
                    ),
                  ),
                ),
                AdaptiveContainer(
                  columnSpan: 12,
                  child: const HomeHighlight(),
                ),
                // AdaptiveContainer(
                //   columnSpan: 12,
                //   child: Column(
                //     children: [
                //       const HomeHighlight(),
                //       LayoutBuilder(
                //         builder: (context, constraints) => HomeArtists(
                //           artists: artists,
                //           constraints: constraints,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // CAN PROB USE THIS ONE TO SELECT TOURNAMENTS IN A SETTING MENU OR SOMETHING
                // AdaptiveContainer(
                //   columnSpan: 12,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 15,
                //           vertical: 10,
                //         ),
                //         child: Text(
                //           'Recently played',
                //           style: context.headlineSmall,
                //         ),
                //       ),
                //       HomeRecent(playlists: playlists),
                //     ],
                //   ),
                // ),
                AdaptiveContainer(
                  columnSpan: 12,
                  child: Flexible(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'Event Teams',
                                  style: context.titleLarge,
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    EventTeams(
                                      event: testEvent
                                    ),
                              )
                            ],
                          ),
                        ),
                ),
                AdaptiveContainer(
                  columnSpan: 12,
                  child: Flexible(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'All Teams',
                                  style: context.titleLarge,
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    EventTeams(
                                      event: testEvent
                                    ),
                              ),
                            ],
                          ),
                        ),
                )
                // AdaptiveContainer(
                //   columnSpan: 12,
                //   child: Padding(
                //     padding: const EdgeInsets.all(15),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Flexible(
                //           flex: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.only(
                //                   left: 8,
                //                   bottom: 8,
                //                 ),
                //                 child: Text(
                //                   'Teams',
                //                   style: context.titleLarge,
                //                 ),
                //               ),
                //               LayoutBuilder(
                //                 builder: (context, constraints) =>
                //                     PlaylistSongs(
                //                       playlist: topSongs,
                //                       constraints: constraints,
                //                     ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         const SizedBox(width: 25),
                //         Flexible(
                //           flex: 10,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.only(
                //                   left: 8,
                //                   bottom: 8,
                //                 ),
                //                 child: Text(
                //                   'New Releases',
                //                   style: context.titleLarge,
                //                 ),
                //               ),
                //               LayoutBuilder(
                //                 builder: (context, constraints) =>
                //                     PlaylistSongs(
                //                       playlist: newReleases,
                //                       constraints: constraints,
                //                     ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
