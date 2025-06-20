// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ftc_tournament_scout/src/utils/adaptive_column.dart';
import 'package:ftc_tournament_scout/src/utils/adaptive_components.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
import '../../../shared/views/adaptive_image_card.dart';
import '../../../shared/views/views.dart';
import 'event_teams.dart';
import './teams_view_model.dart';

class TeamScreen extends StatelessWidget {
  TeamScreen({required this.teamNumber, required this.viewModel, super.key});

  final int teamNumber;
  final TeamsViewModel viewModel;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colors = Theme.of(context).colorScheme;
        final double headerHeight = constraints.isMobile
            ? max(constraints.biggest.height * 0.5, 450)
            : max(constraints.biggest.height * 0.25, 250);
        // if (constraints.isMobile) {
        // }
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.teams.firstWhere((team) => team.number == teamNumber).name),
            toolbarHeight: kToolbarHeight,
          ),
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: true,
                  // controller: numberController,
                  decoration: const InputDecoration(labelText: "Team Number"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return "Enter a valid team number.";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// BackButton(
//   onPressed: () => GoRouter.of(context).go('/teams'),
// ),

// Text(viewModel.teams.firstWhere((team) => team.number == teamNumber).name)