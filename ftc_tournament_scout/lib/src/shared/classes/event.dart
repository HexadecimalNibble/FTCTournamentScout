// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import './classes.dart';

class Event {
  const Event({
    required this.date,
    required this.name,
    required this.teams,
    required this.matches
  });

  final String date;
  final String name;
  final List<Team> teams;
  final List<Match> matches;
}
