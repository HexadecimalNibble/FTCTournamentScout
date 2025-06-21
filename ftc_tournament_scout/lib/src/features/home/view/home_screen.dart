// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
import '../../../shared/providers/providers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/views/views.dart';
import '../../../utils/adaptive_components.dart';
import '../../teams/view/event_teams.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // if (constraints.isMobile) {
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Clickable(
                            child: SizedBox(
                              height: 275,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/news/concert.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () => launchUrl(Uri.parse('https://docs.flutter.dev')),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                // AdaptiveContainer(
                //   columnSpan: 12,
                //   child: Text(
                //     "Selected Event: ${testEvent.name} ${testEvent.date}",
                //     style: context.titleLarge,
                //   ),
                // ),

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

                // AdaptiveContainer(
                //   columnSpan: 12,
                //   child: Flexible(
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
                //                   'Event Teams',
                //                   style: context.titleLarge,
                //                 ),
                //               ),
                //               LayoutBuilder(
                //                 builder: (context, constraints) =>
                //                     EventTeams(
                //                       event: testEvent
                //                     ),
                //               )
                //             ],
                //           ),
                //         ),
                // ),
                // AdaptiveContainer(
                //   columnSpan: 12,
                //   child: Flexible(
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
                //                   'All Teams',
                //                   style: context.titleLarge,
                //                 ),
                //               ),
                //               LayoutBuilder(
                //                 builder: (context, constraints) =>
                //                     EventTeams(
                //                       event: testEvent
                //                     ),
                //               ),
                //             ],
                //           ),
                //         ),
                // )

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
