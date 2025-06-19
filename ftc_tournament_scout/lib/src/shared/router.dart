// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
// import 'package:ftc_tournament_scout/src/features/teams/view/playlist_screen.dart';
import 'package:ftc_tournament_scout/src/shared/classes/classes.dart';
import 'package:go_router/go_router.dart';

import '../features/artists/artists.dart';
import '../features/home/home.dart';
import '../features/teams/teams.dart';
import '../features/teams/view/view.dart';
import 'providers/artists.dart';
// import 'providers/playlists.dart';
import 'providers/team.dart';
import 'views/views.dart';

const _pageKey = ValueKey('_pageKey');
const _scaffoldKey = ValueKey('_scaffoldKey');

final artistsProvider = ArtistsProvider();
// final playlistsProvider = PlaylistsProvider();
// final teamProvider = TeamProvider();

const List<NavigationDestination> destinations = [
  NavigationDestination(label: 'Home', icon: Icon(Icons.home), route: '/'),
  NavigationDestination(
    label: 'Teams',
    icon: Icon(Icons.build),
    route: '/teams',
  ),
  NavigationDestination(
    label: 'Artists',
    icon: Icon(Icons.people),
    route: '/artists',
  ),
];

class NavigationDestination {
  const NavigationDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 0,
          child: HomeScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/teams',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 1,
          child: TeamsHomeScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: ':pid',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: RootLayout(
              key: _scaffoldKey,
              currentIndex: 1,
              // child: TeamsScreen(
              //   playlist: playlistsProvider.getPlaylist(
              //     state.pathParameters['pid']!,
              //   )!,
              // ),
              // child: TeamScreen(
              //   teamProvider.getTeam(
              //     state.pathParameters['pid']!,
              //   )!,
              // )!,
              child: Text("test"),
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/artists',
      pageBuilder: (context, state) => const MaterialPage<void>(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 2,
          child: ArtistsScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: ':aid',
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: RootLayout(
              key: _scaffoldKey,
              currentIndex: 2,
              child: ArtistScreen(
                artist: artistsProvider.getArtist(
                  state.pathParameters['aid']!,
                )!,
              ),
            ),
          ),
        ),
      ],
    ),
    for (final route in destinations.skip(3))
      GoRoute(
        path: route.route,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: _pageKey,
          child: RootLayout(
            key: _scaffoldKey,
            currentIndex: destinations.indexOf(route),
            child: const SizedBox(),
          ),
        ),
      ),
  ],
);
