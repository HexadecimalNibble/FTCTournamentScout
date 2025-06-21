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
        Team team = viewModel.teams.firstWhere((team) => team.number == teamNumber);
        return Scaffold(
          appBar: AppBar(
            title: Text("${team.name} - #${team.number}"),
            toolbarHeight: kToolbarHeight * 2,
            actions: [
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Data saved for Team #${team.number}")),
                    );
                  }
                },
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "General",
                  style: context.titleLarge,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autofocus: true,
                  // controller: numberController,
                  decoration: const InputDecoration(labelText: "Notes"),
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) return null;
                  //   if (value.trim().isEmpty) {
                  //     return "Enter valid text or leave this field blank.";
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 5),
                Text(
                  "Auto",
                  style: context.titleLarge,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Left Side
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Left",
                            style: context.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Select an option',
                              border: OutlineInputBorder(),
                            ),
                            isExpanded: true,
                            items: ['Option 1', 'Option 2', 'Option 3']
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                            onChanged: (value) {
                              // setState(() {
                              //   _selectedValue = value;
                              // });
                            },
                          ),
                        ]
                      )
                    ),
                    // Right Side
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Right",
                            style: context.titleMedium,
                          ),
                          const SizedBox(height: 10),
                        ]
                      )
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "TeleOp",
                  style: context.titleLarge,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 5),
                Text(
                  "End Game",
                  style: context.titleLarge,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Select an option',
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: ['Option 1', 'Option 2', 'Option 3']
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                  onChanged: (value) {
                    // setState(() {
                    //   _selectedValue = value;
                    // });
                  },
                ),
                Text(team.customTeamInfo.toJson().toString())
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