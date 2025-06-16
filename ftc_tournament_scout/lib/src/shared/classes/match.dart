// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import './classes.dart';

class Match {
  const Match({
    required this.title,
    required this.artist,
    required this.length,
    required this.image
});
  final Team artist;
  final String title;
  final Duration length;
  final MyArtistImage image;
}
