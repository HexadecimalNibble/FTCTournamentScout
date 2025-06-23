// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:convert';

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

class TeamScreen extends StatefulWidget {
  final int teamNumber;
  final TeamsViewModel viewModel;

  const TeamScreen({required this.teamNumber, required this.viewModel, super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late Team team;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    team = widget.viewModel.teams.firstWhere((t) => t.number == widget.teamNumber);
    notesController = TextEditingController(text: team.customTeamInfo.notes);
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Widget buildDropdown({
    required String label,
    required List<String> options,
    String? selectedValue,
    void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: selectedValue,
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: onChanged,
    );
  }

  void _saveTeam() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.update.execute(team);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team data saved.'),
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${team.name} - #${team.number}"),
        toolbarHeight: kToolbarHeight * 2,
        actions: [
          IconButton(
            onPressed: _saveTeam,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("General", style: context.titleLarge),
            const SizedBox(height: 10),
            TextFormField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notes"),
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.text,
              onChanged: (value) => setState(() {
                team.customTeamInfo.notes = value;
              }),
            ),
            const SizedBox(height: 20),
            Text("Auto", style: context.titleLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: buildDropdown(
                    label: 'Left Option',
                    options: ['Option 1', 'Option 2', 'Option 3'],
                    onChanged: (value) {
                      // handle left option
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildDropdown(
                    label: 'Right Option',
                    options: ['Option 1', 'Option 2', 'Option 3'],
                    onChanged: (value) {
                      // handle right option
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("End Game", style: context.titleLarge),
            const SizedBox(height: 10),
            buildDropdown(
              label: 'Select End Game Option',
              options: ['Option 1', 'Option 2', 'Option 3'],
              onChanged: (value) {
                // handle end game option
              },
            ),
            Text(team.customTeamInfo.toJson().toString())
          ],
        ),
      ),
    );
  }
}
